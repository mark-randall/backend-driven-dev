//
//  ComponentModel.swift
//  POC
//
//  Created by Mark Randall on 10/22/20.
//

import SwiftUI

class ComponentModel<T>: Identifiable, ComponentModelFactory {
    
    private var dispatcher: ComponentDispatcher?
    private let componentModelFactory: ComponentModelFactory
    
    @State private (set) var state: T // TODO: should this be private?
    
    init(state: T, componentModelFactory: ComponentModelFactory, dispatcher: ComponentDispatcher?) {
        self.state = state
        self.componentModelFactory = componentModelFactory
        self.dispatcher = dispatcher
    }
    
    func dispatch(_ action: ComponentAction) {
        dispatcher?.dispatch(action)
    }
    
    // MARK: - ComponentModelFactory
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T> {
        return componentModelFactory.createComponentModel(state: state)
    }
}
