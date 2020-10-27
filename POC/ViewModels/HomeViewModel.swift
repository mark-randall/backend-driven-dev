//
//  HomeViewModel.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import Foundation

final class HomeViewModel: ViewModel {
    
    // MARK: - ActionChain
    
    override func handleAction(_ action: ComponentAction) -> Bool {
        switch action {
        case .activityLogged(let activity):
            
            // Append .listItem to list component
            updateViewStateComponent(withId: "list") { (s: inout ListComponentState) -> Void in
                let activityView = ComponentState.listItem(ListItemComponentState(content: ListItemComponentState.Content(title: activity.entity)))
                s.content.items.append(activityView)
            }
            
            viewEffect.send(.dismissSheet)
            
            return false
        default:
            return super.handleAction(action)
        }
    }
}
