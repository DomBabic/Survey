//
//  Test+RetryTests.swift
//  SurveyAppTests
//
//  Created by Dominik Babic on 26.03.2024..
//

import XCTest
@testable import SurveyApp

final class Test_RetryTests: XCTestCase {
    
    var count = 0
    let retries = 3
    
    var exp = XCTestExpectation(description: "Expected to succeed.")

    func testRetry() async {
        Task.retry(maxRetryCount: retries, retryDelay: 0.1) { [weak self] in
            guard let self else { return }
            
            if count < retries - 1 {
                count += 1
                throw NSError(domain: "Test", code: 1)
            } else {
                exp.fulfill()
            }
        }
        
        await fulfillment(of: [exp], timeout: 0.5)
    }

}
