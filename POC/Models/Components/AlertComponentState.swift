//
//  AlertComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/22/20.
//

import Foundation

struct AlertComponentState: ComponentStateData, Identifiable {
    
    struct Content: Decodable {
        let title: String
        let message: String?
    }
    
    var id: String = UUID().uuidString
    let content: Content 
}
