//
//  MockServiceLocator.swift
//  POCTests
//
//  Created by Mark Randall on 10/27/20.
//

@testable import POC
import Nock
import Combine

final class MockServiceLocator: ServiceLocatorProtocol {
    
    let nock = Nock()
    
    lazy var screenRepository: ScreenRepositoryProtocol = { [unowned self] in
        MockScreenRepository(nock: self.nock)
    }()
    
    lazy var activityRepository: ActivityRepositoryProtocol = { [unowned self] in
        MockActivityRepository(nock: self.nock)
    }()
    
    init() {
        let emptyScreen = ComponentState.screen(ScreenComponentState(id: "_", content: ScreenComponentState.Content(title: "_"), components: []))
        let emptyScreenResult = Result<ComponentState, ScreenRespositoryError>.success(emptyScreen)
        nock.when(MockScreenRepositoryMembers.fetchScreen).then(return: Just(emptyScreenResult).eraseToAnyPublisher())
    }
}
