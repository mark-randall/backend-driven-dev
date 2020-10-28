//
//  ListView.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var componentModel: ComponentModel<ListComponentState>
    
    var body: some View {
        if !componentModel.state.content.items.isEmpty {
            List {
                ForEach(componentModel.state.content.items) { item in
                    ComponentView(componentModelFactory: componentModel, component: item)
                }
            }
        } else if let emptyState = componentModel.state.content.emptyState {
            ComponentsView(componentModelFactory: componentModel, components: emptyState, spacing: 8.0)
        }
    }
}
