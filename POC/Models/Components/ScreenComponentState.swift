//
//  ScreenComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

struct ScreenComponentState: ComponentStateData {
    
    struct Content: Decodable {
        let title: String
        var navigationButtonsTrailing: [ComponentState]? = []
    }
    
    let id: String
    var content: Content
    var components: [ComponentState]
}
