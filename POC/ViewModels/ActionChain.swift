//
//  ComponentDispatcher.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

// MARK: - ActionReceiver

protocol ActionReceiver: class {
    
    func dispatch(_ action: ComponentAction)
}

// MARK: - ActionHandler

protocol ActionHandler: class {
    
    var nextHandler: ActionReceiver? { get }
    
    func handleAction(_ action: ComponentAction) -> Bool
}

// MARK: - ActionChain

protocol ActionChain: ActionReceiver, ActionHandler {}

extension ActionChain {
    
    func dispatch(_ action: ComponentAction) {
        if handleAction(action) {
            nextHandler?.dispatch(action)
        }
    }
    
    func handleAction(_ action: ComponentAction) -> Bool {
        return true
    }
}
