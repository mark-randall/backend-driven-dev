//
//  TextBlockComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation

struct TextBlockComponentState: ComponentStateData, Identifiable {
    
    struct Content: Decodable {
        var blocks: [TextState]
    }
    
    struct Options: Decodable {
        var spacing: Double = 8
    }
    
    var id: String = UUID().uuidString
    var content: Content
    var options: Options? = Options()
}
