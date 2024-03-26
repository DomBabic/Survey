//
//  SurveyResultTests.swift
//  SurveyAppTests
//
//  Created by Dominik Babic on 26.03.2024..
//

import XCTest
import SwiftUI
@testable import SurveyApp

final class SurveyResultTests: XCTestCase {

    func testTitle() {
        var act = SurveyResult.success
        var exp = "Success!"
        
        XCTAssertEqual(act.title, exp)
        
        act = .failure(answer: .init(id: 0, answer: ""))
        exp = "Failure...."
        
        XCTAssertEqual(act.title, exp)
    }
    
    func testBackground() {
        var act = SurveyResult.success
        var exp = Color.green
        
        XCTAssertEqual(act.background, exp)
        
        act = .failure(answer: .init(id: 0, answer: ""))
        exp = .red
        
        XCTAssertEqual(act.background, exp)
    }
    
    func testEqual() {
        var lhs = SurveyResult.success
        var rhs = SurveyResult.success
        XCTAssertEqual(lhs, rhs)
        
        lhs = .failure(answer: .init(id: 0, answer: ""))
        XCTAssertNotEqual(lhs, rhs)
        
        rhs = .failure(answer: .init(id: 0, answer: ""))
        XCTAssertEqual(lhs, rhs)
        
        rhs = .failure(answer: .init(id: 1, answer: ""))
        XCTAssertNotEqual(lhs, rhs)
    }
}
