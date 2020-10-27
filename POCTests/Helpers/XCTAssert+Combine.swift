//
//  XCTAssert+Combine.swift
//  UmbrellaTests
//
//  Created by Mark Randall on 8/4/20.
//  Copyright © 2020 The Nerdery. All rights reserved.
//

import XCTest
import Combine

// Assert emitted values are equal to expression
func AssertNextEmittedOutputEquals<T: Publisher>(
    expectation: XCTestExpectation,
    publisher: T,
    _ expression1: @autoclosure () throws -> [T.Output],
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> AnyCancellable where T.Output: Equatable {
    
    let expected: [T.Output] = (try? XCTUnwrap(try? expression1())) ?? []
    let message = message()
    var values: [T.Output] = []
    return publisher.sink(receiveCompletion: { _ in }, receiveValue: {
        values.append($0)
        if values.count == expected.count {
            expectation.fulfill()
            XCTAssertEqual(values, expected, message, file: file, line: line)
        }
    })
}
