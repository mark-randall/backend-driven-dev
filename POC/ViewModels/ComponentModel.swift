//
//  ComponentModel.swift
//  POC
//
//  Created by Mark Randall on 10/22/20.
//

import SwiftUI

class ComponentModel<T>: ObservableObject, Identifiable, ComponentModelFactory, ActionChain {

    // MARK: - State
    
    @Published private(set) var state: T
    
    // MARK: - ActionChain
    
    weak var nextHandler: ActionReceiver?
    
    // MARK: - Dependencies
    
    private let componentModelFactory: ComponentModelFactory
    
    // MARK: - Init
    
    init(state: T, componentModelFactory: ComponentModelFactory, nextHandler: ActionReceiver?) {
        self.state = state
        self.componentModelFactory = componentModelFactory
        self.nextHandler = nextHandler
    }
    
    // MARK: - ComponentModelFactory
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T> {
        return componentModelFactory.createComponentModel(state: state)
    }
}
