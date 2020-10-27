//
//  ComponentModelFactory.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

protocol ComponentModelFactory {
    
    func createComponentModel<T>(state: ComponentState) -> ComponentModel<T>
}
