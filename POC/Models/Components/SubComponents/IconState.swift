//
//  IconState.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

struct IconState: Decodable {
    
    enum Source: String, Decodable {
        case url
        case symbol
    }
    
    let type: Source
    let value: String
}
