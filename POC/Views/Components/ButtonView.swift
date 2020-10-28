//
//  ButtonView.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import SwiftUI

struct ButtonView: View {
    
    @ObservedObject var componentModel: ComponentModel<ButtonComponentState>
    
    var body: some View {
        Button(action: {
            guard let action = self.componentModel.state.selectionAction else { return }
            componentModel.dispatch(action)
        }) {
            if let title = componentModel.state.content.title {
                Text(title)
            }
        }
    }
}
