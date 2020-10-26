//
//  IconComponentModel.swift
//  POC
//
//  Created by Mark Randall on 10/23/20.
//

struct IconComponentModel: Decodable {
    
    enum Source: String, Decodable {
        case url
        case symbol
    }
    
    let type: Source
    let value: String
}
