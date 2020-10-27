//
//  ListItemComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation

struct ListItemComponentState: ComponentStateData {
    
    struct Content: Decodable {
        var icon: IconState? = nil
        var title: String
        var subTitle: String? = nil
        var disclosureIndicator: String? = nil
    }
    
    var id: String = UUID().uuidString
    var content: Content
    var selectionAction: ComponentAction? = nil
}
