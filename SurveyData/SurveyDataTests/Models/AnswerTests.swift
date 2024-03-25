//
//  AnswerTests.swift
//  SurveyDataTests
//
//  Created by Dominik Babic on 25.03.2024..
//

import XCTest
@testable import SurveyData

final class AnswerTests: XCTestCase {
    
    func testEncoding() throws {
        let answer = Answer(id: 1, answer: "Blue")
        
        let encoded = try JSONEncoder().encode(answer)
        
        let string = String(data: encoded, encoding: .utf8)
        
        XCTAssertTrue(string?.contains("id") ?? false)
        XCTAssertTrue(string?.contains("1") ?? false)
        XCTAssertTrue(string?.contains("answer") ?? false)
        XCTAssertTrue(string?.contains("Blue") ?? false)
    }

}
