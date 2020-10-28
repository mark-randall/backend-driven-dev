//
//  ListItemView.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import SwiftUI

struct ListItemView: View {
    
    @ObservedObject var componentModel: ComponentModel<ListItemComponentState>
    
    var body: some View {
        Button(action: {
            guard let action = self.componentModel.state.selectionAction else { return }
            componentModel.dispatch(action)
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(componentModel.state.content.title)
                        .font(.body)
                        .foregroundColor(.primary)
                    if let subTitle = componentModel.state.content.subTitle {
                        Spacer()
                        Text(subTitle)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if let value = componentModel.state.content.value {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}
