//
//  MockAPIClient.swift
//  UmbrellaTests
//
//  Created by Mark Randall on 8/4/20.
//  Copyright © 2020 The Nerdery. All rights reserved.
//

import Foundation
import Combine
@testable import POC
import Nock

struct MockScreenRepositoryMembers {
    
    static let fetchScreen = NockMethod<ScreenRepositoryProtocol, String, AnyPublisher<Result<ComponentState, ScreenRespositoryError>, Never>>()
}

struct MockScreenRepository: ScreenRepositoryProtocol {

    let nock: Nock
    
    func fetchScreen(forId id: String) -> AnyPublisher<Result<ComponentState, ScreenRespositoryError>, Never> {
        return try! nock.callMethod(MockScreenRepositoryMembers.fetchScreen, params: id)
    }
}
