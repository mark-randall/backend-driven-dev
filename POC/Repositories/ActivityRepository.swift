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

    func logActivity(entity: String, value: Double, date: Date) -> AnyPublisher<Result<Bool, Error>, Never>
}

// MARK: - ActivityRepository

final class ActivityRepository: ActivityRepositoryProtocol {
    
    func logActivity(entity: String, value: Double, date: Date = Date()) -> AnyPublisher<Result<Bool, Error>, Never> {
        
        return Future { promise in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                promise(.success(.success(true)))
            }
        }.eraseToAnyPublisher()
        
    }
}
