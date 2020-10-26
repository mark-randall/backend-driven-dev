//
//  Component.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine

protocol ComponentStateData: Decodable {} // TODO: should protocol be Identifable

enum ComponentState: Decodable, Identifiable {
    
    case screen(ScreenComponentState)
    case list(ListComponentState)
    case listItem(ListItemComponentState)
     
    // MARK: - Identifiable
    
    var id: String { String(describing: self) }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        
        enum CodingKeys: String, CodingKey {
            case type
            case data
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "screen":
            self = .screen(try container.decode(ScreenComponentState.self, forKey: .data))
        case "list":
            self = .list(try container.decode(ListComponentState.self, forKey: .data))
        case "listItem":
            self = .listItem(try container.decode(ListItemComponentState.self, forKey: .data))
        default:
            preconditionFailure("Action type not supported")
        }
    }
}
