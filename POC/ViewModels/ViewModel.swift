//
//  ViewModel.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine
import SwiftUI

protocol ComponentModelFactory {
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T>
}

class ViewModel: ObservableObject, Identifiable, ComponentModelFactory {
    
    // MARK: - State and ViewEffect
    
    struct ViewState {
        var showActivityIndicator = false
        var title = ""
        var components: [ComponentState] = []
    }
    
    enum ViewEffect {
        case presentAlert(AlertComponentState)
        case presentNavigationLink(ViewModel)
        case presentSheet(ViewModel)
    }
    
    @Published private(set) var viewState = ViewState()
    
    let viewEffect = PassthroughSubject<ViewEffect, Never>()
    
    let isNavigationView: Bool
    let navigationViewDisplayMode: NavigationBarItem.TitleDisplayMode
    
    
    // MARK: - Dependencies
    
    private let screenRepository = ScreenRepository()
    
    private let dispatcherSubject = PassthroughSubject<ComponentAction, Never>()
    private lazy var dispatcher: ComponentDispatcher = { [unowned self] in ComponentDispatcher(subject: self.dispatcherSubject) }()
    
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(
        screenId: String,
        isNavigationView: Bool = false,
        navigationViewDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    ) {
        self.isNavigationView = isNavigationView
        self.navigationViewDisplayMode = navigationViewDisplayMode
        
        // Fetch screen data from repository
        viewState.showActivityIndicator = true
        screenRepository.fetchScreen(forId: screenId)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.viewState.showActivityIndicator = false
                
                switch result {
                case .failure(let error):
                    print(error)
                    let alert = AlertComponentState(content: AlertComponentState.Content(title: error.localizedDescription, message: nil))
                    self.viewEffect.send(.presentAlert(alert))
                case .success(let componentState):
                    if case .screen(let screenState) = componentState {
                        self.viewState.title = screenState.content.title
                        self.viewState.components = screenState.components
                    }
                }
            }).store(in: &subscriptions)
        
        dispatcherSubject.sink(receiveValue: { [weak self] action in
            self?.apply(action)
        }).store(in: &subscriptions)
    }
    
    deinit {
        print("VM Deinit")
    }
    
    // MARK: - Apply ComponentAction
    
    private func apply(_ action: ComponentAction) {
        
        switch action {
        case .navigation(let showAction):
            switch showAction.transition {
            case .navigationLink:
                viewEffect.send(.presentNavigationLink(ViewModel(screenId: showAction.screenId, isNavigationView: false)))
            case .sheet:
                viewEffect.send(.presentSheet(ViewModel(screenId: showAction.screenId, isNavigationView: true, navigationViewDisplayMode: .inline)))
            }
        }
    }
    
    // MARK: - ComponentModelFactory
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T> {
        
        let specializedState: T
        switch state {
        case .list(let stateData):
            specializedState = stateData as! T
        case .listItem(let stateData):
            specializedState = stateData as! T
        default:
            preconditionFailure()
        }
        
        return ComponentModel(
            state: specializedState,
            componentModelFactory: self,
            dispatcher: dispatcher
        )
    }
}
