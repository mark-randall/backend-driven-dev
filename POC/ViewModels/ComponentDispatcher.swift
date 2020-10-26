//
//  ComponentDispatcher.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import Combine

class ComponentDispatcher: Identifiable {
        
    private let subject: PassthroughSubject<ComponentAction, Never>
    lazy var action: AnyPublisher<ComponentAction, Never> = { subject.eraseToAnyPublisher() }()
    
    init(subject: PassthroughSubject<ComponentAction, Never> = PassthroughSubject<ComponentAction, Never>()) {
        self.subject = subject
    }
    
    func dispatch(_ action: ComponentAction) {
        subject.send(action)
    }
}
