//
//  ComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine

protocol ComponentStateData: Decodable {
    var id: String { get }
}

enum ComponentState: Decodable, Identifiable, Equatable {

    case screen(ScreenComponentState)
    case list(ListComponentState)
    case listItem(ListItemComponentState)
    case button(ButtonComponentState)
    case textBlock(TextBlockComponentState)
    
    // MARK: - Equatable
    
    static func == (lhs: ComponentState, rhs: ComponentState) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
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
        case "button":
            self = .button(try container.decode(ButtonComponentState.self, forKey: .data))
        case "textBlock":
            self = .textBlock(try container.decode(TextBlockComponentState.self, forKey: .data))
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
        case let stateData as ButtonComponentState:
            self = .button(stateData)
        case let stateData as TextBlockComponentState:
            self = .textBlock(stateData)
        default:
            return nil
        }
    }

    var rawValue: ComponentStateData {
        switch self {
        case .screen(let state): return state
        case .list(let state): return state
        case .listItem(let state): return state
        case .button(let state): return state
        case .textBlock(let state): return state
        }
    }
}
