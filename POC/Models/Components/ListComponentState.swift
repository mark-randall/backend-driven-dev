//
//  ListComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation

struct ListComponentState: ComponentStateData {
    
    struct Content: Decodable {
        var items: [ComponentState]
    }
    
    var id: String = UUID().uuidString
    var content: Content
}
