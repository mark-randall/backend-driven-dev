//
//  ListComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Combine

struct ListComponentState: ComponentStateData {
    
    struct Content: Decodable {
        let items: [ComponentState]
    }
    
    let content: Content
}
