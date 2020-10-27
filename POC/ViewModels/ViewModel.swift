//
//  ViewModel.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject, Identifiable, ComponentModelFactory, ActionChain {

    // MARK: - State and ViewEffect
    
    struct ViewState {
        var showActivityIndicator = false
        var title = ""
        var isNavigationView: Bool = false
        var navigationViewDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
        var components: [ComponentState] = []
    }
    
    enum ViewEffect {
        case presentAlert(AlertComponentState)
        case presentNavigationLink(ViewModel)
        case presentSheet(ViewModel)
        case dismissSheet
    }
    
    @Published private(set) var viewState = ViewState()
    
    let viewEffect = PassthroughSubject<ViewEffect, Never>()
    
    // MARK: - ActionChain
    
    weak var nextHandler: ActionReceiver?
        
    // MARK: - Dependencies
    
    private let screenRepository = ScreenRepository()
    
    private let activityRepository = ActivityRepository()
        
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Init
    
    init(
        screenId: String,
        nextHandler: ActionReceiver? = nil,
        viewState: ViewState = ViewState()
    ) {
        self.nextHandler = nextHandler
        self.viewState = viewState
   
        // Fetch screen data from repository
        self.viewState.showActivityIndicator = true
        screenRepository.fetchScreen(forId: screenId)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.viewState.showActivityIndicator = false
                
                switch result {
                case .failure(let error):
                    let alert = AlertComponentState(content: AlertComponentState.Content(title: error.localizedDescription, message: nil))
                    self.viewEffect.send(.presentAlert(alert))
                case .success(let componentState):
                    if case .screen(let screenState) = componentState {
                        self.viewState.title = screenState.content.title
                        self.viewState.components = screenState.components
                    }
                }
            }).store(in: &subscriptions)
    }
    
    // MARK: - ActionChain
    
    func handleAction(_ action: ComponentAction) -> Bool {
        
        switch action {
        
        case .navigation(let showAction):
            switch showAction.transition {
            case .navigationLink:
                let vm = ViewModel(
                    screenId: showAction.screenId,
                    nextHandler: self
                )
                viewEffect.send(.presentNavigationLink(vm))
            case .sheet:
                let vm = ViewModel(
                    screenId: showAction.screenId,
                    nextHandler: self,
                    viewState: ViewModel.ViewState(isNavigationView: true, navigationViewDisplayMode: .inline)
                )
                viewEffect.send(.presentSheet(vm))
            }
            return false

        case .logActivity(let activity):
            viewState.showActivityIndicator = true
            activityRepository.logActivity(activity)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] result in
                
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let activityLog):
                        self?.viewState.showActivityIndicator = false
                        self?.dispatch(.activityLogged(activityLog))
                    }
                }).store(in: &subscriptions)
            return false

        case .activityLogged:
            return true
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
            nextHandler: self
        )
    }
    
    // MARK: - ViewState modification
    
    func updateViewState(_ update: (inout ViewState) -> Void) {
        update(&viewState)
    }
    
    func updateViewStateComponent<T: ComponentStateData>(withId id: String, _ update: (inout T) -> Void) {
        guard let componentIndex: Int = viewState.components.firstIndex(where: { $0.id == id }) else { return }
        guard var componentStateData = viewState.components[componentIndex].rawValue as? T else { return }
        update(&componentStateData)
        guard let updatedComponentState = ComponentState(rawValue: componentStateData) else { return }
        viewState.components[componentIndex] = updatedComponentState
    }
}
