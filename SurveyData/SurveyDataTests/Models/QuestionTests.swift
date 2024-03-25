//
//  QuestionTests.swift
//  SurveyDataTests
//
//  Created by Dominik Babic on 25.03.2024..
//

import XCTest
@testable import SurveyData

final class QuestionTests: XCTestCase {

    let correctJSON = """
    [
        {
            "id": 1,
            "question": "What is your favourite colour?"
        },
        {
            "id": 2,
            "question": "What is your favourite food?"
        }
    ]
    """
    
    let malformedJSON = """
    [
        {
            "id": 1
        }
    ]
    """
    
    func testDecoding() throws {
        let correctData = correctJSON.data(using: .utf8)
        let decoded = try JSONDecoder().decode([Question].self, from: correctData!)
        
        XCTAssertEqual(decoded.count, 2)
        XCTAssertTrue(decoded.contains(where: { $0.id == 1 && $0.question == "What is your favourite colour?" }))
    }
    
    func testMalformed() {
        let malformedData = malformedJSON.data(using: .utf8)
        
        do {
            _ = try JSONDecoder().decode([Question].self, from: malformedData!)
            XCTFail("Data should not be decoded.")
        } catch let error {
            XCTAssertTrue(error is DecodingError)
        }
    }

}
