//
//  MockActivityRepository.swift
//  POCTests
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation
import Combine
@testable import POC
import Nock

struct MockActivityRepositoryMembers {
    
    static let logActivity = NockMethod<ActivityRepositoryProtocol, Params2<LogActivityAction, Date>, AnyPublisher<Result<ActivityLog, Error>, Never>>()
}

struct MockActivityRepository: ActivityRepositoryProtocol {

    let nock: Nock

    func logActivity(_ activity: LogActivityAction, date: Date) -> AnyPublisher<Result<ActivityLog, Error>, Never> {
        return try! nock.callMethod(MockActivityRepositoryMembers.logActivity, params: Params2(activity, date))
    }
}

