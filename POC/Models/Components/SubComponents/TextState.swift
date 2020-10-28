//
//  TextState.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation
import SwiftUI

struct TextState: Decodable, Identifiable, Equatable {
    
    enum Font: String, Decodable { // TODO: improve
        case body
        case subheadline
        
        var font: SwiftUI.Font {
            switch self {
            case .body: return .body
            case .subheadline: return .subheadline
            }
        }
    }
    
    var id: String = UUID().uuidString
    let text: String
    let font: Font
}
