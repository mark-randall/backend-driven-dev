//
//  ViewModelTests.swift
//  POCTests
//
//  Created by Mark Randall on 10/27/20.
//

import XCTest
@testable import POC
import Nock
import Combine



class ViewModelTests: XCTestCase {

    private var subscriptions: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions = []
    }

    func testDispach_updateScreen() throws {
        
        // Arrange
        let vm = ViewModel(screenId: "test", serviceLocator: MockServiceLocator())
        
        // Act
        vm.dispatch(.updateScreen(ScreenComponentState(id: "id", content: ScreenComponentState.Content(title: "title"), components: [])))
        
        // Assert
        XCTAssertEqual(vm.viewState.title, "title")
    }
    
    func testDispach_navigationSheet_viewEffectEmits() throws {
        
        // Arrange
        let vm = ViewModel(screenId: "test", serviceLocator: MockServiceLocator())
        let e = expectation(description: "testDispach_updateScreen2")
        AssertNextEmittedOutputEquals(
            expectation: e,
            publisher: vm.viewEffect,
            [ViewModel.ViewEffect.presentSheet(ViewModel(screenId: "sheet", viewState: ViewModel.ViewState(isNavigationView: true, navigationViewDisplayMode: .inline)))]
        ).store(in: &subscriptions)
        
        // Act
        vm.dispatch(.navigation(NavigationAction(transition: .sheet, screenId: "sheet")))

        // Assert
        wait(for: [e], timeout: 1.0)
    }
}
