//
//  ComponentsView.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import SwiftUI

struct ComponentsView: View {
    
    let componentModelFactory: ComponentModelFactory
    let components: [ComponentState]
    
    var body: some View {
        VStack {
            ForEach(components) { component in
                ComponentView(componentModelFactory: componentModelFactory, component: component)
            }
        }
    }
}

struct ComponentView: View {
    
    let componentModelFactory: ComponentModelFactory
    let component: ComponentState
    
    var body: some View {
        switch component {
        case .list:
            ListView(componentModel: componentModelFactory.createComponentModel(state: component))
        case .listItem:
            ListItemView(componentModel: componentModelFactory.createComponentModel(state: component))
        default:
            preconditionFailure()
        }
    }
}
