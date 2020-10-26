//
//  ListItemComponentState.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

struct ListItemComponentState: ComponentStateData {
    
    struct Content: Decodable {
        let icon: IconComponentModel?
        let title: String
        let subTitle: String? = "Did it work"
        let disclosureIndicator: String?
    }
    
    let content: Content
    let selectionAction: ComponentAction?
}
