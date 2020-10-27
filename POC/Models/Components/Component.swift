//
//  Component.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine

protocol ComponentStateData: Decodable {
    var id: String { get }
}

enum ComponentState: Decodable, Identifiable {
    
    case screen(ScreenComponentState)
    case list(ListComponentState)
    case listItem(ListItemComponentState)
     
    // MARK: - Identifiable
    
    var id: String { rawValue.id }
    
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

// MARK: - RawRepresentable

extension ComponentState: RawRepresentable {

    init?(rawValue: ComponentStateData) {
        switch rawValue {
        case let stateData as ScreenComponentState:
            self = .screen(stateData)
        case let stateData as ListComponentState:
            self = .list(stateData)
        case let stateData as ListItemComponentState:
            self = .listItem(stateData)
        default:
            return nil
        }
    }

    var rawValue: ComponentStateData {
        switch self {
        case .screen(let state): return state
        case .list(let state): return state
        case .listItem(let state): return state
        }
    }
}
