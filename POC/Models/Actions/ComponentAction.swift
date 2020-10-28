//
//  ComponentAction.swift
//  POC
//
//  Created by Mark Randall on 10/22/20.
//

import Foundation

enum ComponentAction: Decodable, Equatable {
    
    case updateScreen(ScreenComponentState)
    case navigation(NavigationAction)
    case logActivity(LogActivityAction)
    case activityLogged(ActivityLog)
    case presentAlert(AlertComponentState)
    
    // MARK: - Equatable
        
    static func == (lhs: ComponentAction, rhs: ComponentAction) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    // MARK: - Decodable
    
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
        case "logActivity":
            self = .logActivity(try container.decode(LogActivityAction.self, forKey: .data))
        default:
            throw ScreenRespositoryError.invalidActionType
        }
    }
}
