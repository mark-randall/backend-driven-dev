//
//  ServiceLocator.swift
//  POC
//
//  Created by Mark Randall on 10/27/20.
//

import Foundation

protocol ServiceLocatorProtocol {
    var screenRepository: ScreenRepositoryProtocol { get }
    var activityRepository: ActivityRepositoryProtocol { get }
}

final class ServiceLocator: ServiceLocatorProtocol {
    lazy var screenRepository: ScreenRepositoryProtocol = ScreenRepository()
    lazy var activityRepository: ActivityRepositoryProtocol = ActivityRepository()
}
