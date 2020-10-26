//
//  ScreenComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

struct ScreenComponentState: ComponentStateData {
    
    struct Content: Decodable {
        let title: String
    }
    
    let id: String
    let content: Content
    let components: [ComponentState]
}
