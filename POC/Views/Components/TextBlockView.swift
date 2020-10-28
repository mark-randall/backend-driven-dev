//
//  TextBlockView.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import SwiftUI

struct TextBlockView: View {
    
    @ObservedObject var componentModel: ComponentModel<TextBlockComponentState>
    
    var body: some View {
        VStack(spacing: CGFloat(componentModel.state.options?.spacing ?? 0)) {
            ForEach(componentModel.state.content.blocks) { textBlock in
                Text(textBlock.text)
                    .font(textBlock.font.font)
            }
        }
    }
}
