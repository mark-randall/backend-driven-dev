//
//  NavigationAction.swift
//  POC
//
//  Created by Mark Randall on 10/23/20.
//

struct NavigationAction: Decodable {
    
    enum Transition: String, Decodable {
        case sheet
        case navigationLink
    }
    
    let transition: Transition
    let screenId: String
}
