//
//  ButtonComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation

struct ButtonComponentState: ComponentStateData, Identifiable, Equatable {
    
    struct Content: Decodable, Equatable {
        var icon: IconState? = nil
        var title: String? = nil
    }
    
    var id: String = UUID().uuidString
    var content: Content
    var selectionAction: ComponentAction? = nil
}
