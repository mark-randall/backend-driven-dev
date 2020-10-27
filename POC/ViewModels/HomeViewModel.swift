//
//  HomeViewModel.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import Foundation

class HomeViewModel: ViewModel {
    
    // MARK: - ActionChain
    
    override func handleAction(_ action: ComponentAction) -> Bool {
        switch action {
        case .activityLogged:
            // TODO: How to update UI with logged activity
            viewEffect.send(.dismissSheet)
            return false
        default:
            return super.handleAction(action)
        }
    }
}
