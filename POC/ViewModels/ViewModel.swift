//
//  ViewModel.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject, Identifiable, ComponentModelFactory, ActionChain, Equatable {
    
    // MARK: - Equatable
    
    static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
        lhs.screenId == rhs.screenId && lhs.viewState == rhs.viewState
    }
    
    // MARK: - State and ViewEffect
    
    struct ViewState: Equatable {
        var isNavigationView: Bool = false
        var title = ""
        var navigationViewButtonsTrailing: [ComponentState] = []
        var navigationViewDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
        var components: [ComponentState] = []
        var showActivityIndicator = false
    }
    
    enum ViewEffect: Equatable {
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
    
    private let serviceLocator: ServiceLocatorProtocol
        
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Init
    
    let screenId: String
    
    init(
        screenId: String,
        nextHandler: ActionReceiver? = nil,
        viewState: ViewState = ViewState(),
        serviceLocator: ServiceLocatorProtocol = ServiceLocator()
    ) {
        self.screenId = screenId
        self.serviceLocator = serviceLocator
        self.nextHandler = nextHandler
        self.viewState = viewState
        
        fetchScreen(screenId: screenId)
    }
    
    private func fetchScreen(screenId: String) {
   
        // Fetch screen data from repository
        self.viewState.showActivityIndicator = true
        serviceLocator.screenRepository.fetchScreen(forId: screenId)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.viewState.showActivityIndicator = false
                switch result {
                case .failure(let error):
                    let alert = AlertComponentState(content: AlertComponentState.Content(title: error.localizedDescription, message: nil))
                    self?.dispatch(.presentAlert(alert))
                case .success(let componentState):
                    guard  case .screen(let screenState) = componentState else { preconditionFailure() }
                    self?.dispatch(.updateScreen(screenState))
                }
            }).store(in: &subscriptions)
    }
    
    // MARK: - ActionChain
    
    func handleAction(_ action: ComponentAction) -> Bool {
        
        switch action {
        
        case .updateScreen(let screenState):
            self.viewState.title = screenState.content.title
            self.viewState.components = screenState.components
            self.viewState.navigationViewButtonsTrailing = screenState.content.navigationButtonsTrailing ?? []
            return false
        
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
            serviceLocator.activityRepository.logActivity(activity, date: Date())
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] result in
                
                    switch result {
                    case .failure(let error):
                        let alert = AlertComponentState(content: AlertComponentState.Content(title: error.localizedDescription, message: nil))
                        self?.dispatch(.presentAlert(alert))
                    case .success(let activityLog):
                        self?.viewState.showActivityIndicator = false
                        self?.dispatch(.activityLogged(activityLog))
                    }
                }).store(in: &subscriptions)
            return false

        case .presentAlert(let alert):
            self.viewEffect.send(.presentAlert(alert))
            return false
            
        case .activityLogged:
            return true
        }
    }
    
    // MARK: - ComponentModelFactory
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T> {
        return ComponentModel(
            state: state.rawValue as! T, // TODO: Consider throwing error
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
