//
//  ActivityRepository.swift
//  POC
//
//  Created by Mark Randall on 10/26/20.
//

import Combine
import Foundation

// MARK: - ActivityRepositoryProtocol

protocol ActivityRepositoryProtocol {

    func logActivity(_ activity: LogActivityAction, date: Date) -> AnyPublisher<Result<ActivityLog, Error>, Never>
}

// MARK: - ActivityRepository

final class ActivityRepository: ActivityRepositoryProtocol {
    
    func logActivity(_ activity: LogActivityAction, date: Date = Date()) -> AnyPublisher<Result<ActivityLog, Error>, Never> {
        
        return Future { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success(.success(ActivityLog(created: date, entity: activity.entity, value: activity.value))))
            }
        }.eraseToAnyPublisher()
        
    }
}
