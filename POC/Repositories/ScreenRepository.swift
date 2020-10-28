//
//  ScreenRepository.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import Foundation
import Combine

// MARK: - ScreenRespositoryError

enum ScreenRespositoryError: LocalizedError, CustomStringConvertible {
    case invalidActionType
    case invalidComponentType
    case notFound
    case invalidFormat
    case error(Error)
    
    var errorDescription: String? { "Error loading screen" }
    
    var failureReason: String? {
        switch self {
        case .invalidActionType:
            return "Invalid component type value"
        case .invalidComponentType:
            return "Invalid component type value"
        case .notFound:
            return "Screen not found for id"
        case .invalidFormat:
            return "Screen data is invalid"
        case .error(let error):
            return ((error as? LocalizedError)?.failureReason) ?? error.localizedDescription
        }
    }
    
    var description: String {
        "ScreenRespositoryError: \(errorDescription ?? "Error"): \(failureReason ?? "Unknown failure reasion")"
    }
}

// MARK: - ScreenRepositoryProtocol

protocol ScreenRepositoryProtocol {

    func fetchScreen(forId id: String) -> AnyPublisher<Result<ComponentState, ScreenRespositoryError>, Never>
}

// MARK: - ScreenRepository

final class ScreenRepository: ScreenRepositoryProtocol {
    
    func fetchScreen(forId id: String) -> AnyPublisher<Result<ComponentState, ScreenRespositoryError>, Never> {
        
        return Future { promise in
        
            do {
                
                // Load screen data
                guard let path = Bundle.main.path(forResource: id, ofType: "json") else { throw ScreenRespositoryError.notFound }
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                // Decode into Screen ComponentState
                let componentState = try JSONDecoder().decode(ComponentState.self, from: data)
                promise(.success(.success(componentState)))
 
            } catch let error as ScreenRespositoryError {
                print(error)
                promise(.success(.failure(error)))
            } catch {
                print(error)
                promise(.success(.failure(.error(error))))
            }
            
        }
        .eraseToAnyPublisher()
    }
}
