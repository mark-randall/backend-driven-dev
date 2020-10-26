//
//  ComponentAction.swift
//  POC
//
//  Created by Mark Randall on 10/22/20.
//

import Foundation

enum ComponentAction: Decodable {
    
    case navigation(NavigationAction)
    
    init(from decoder: Decoder) throws {
        
        enum CodingKeys: String, CodingKey {
            case type
            case data
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "navigation":
            self = .navigation(try container.decode(NavigationAction.self, forKey: .data))
        default:
            preconditionFailure("Action type not supported")
        }
    }
}
