//
//  SurveyViewStateTests.swift
//  SurveyAppTests
//
//  Created by Dominik Babic on 26.03.2024..
//

import XCTest
@testable import SurveyApp

final class SurveyViewStateTests: XCTestCase {

    func testIdentifiable() {
        var act = SurveyViewState.loading
        var exp = 0
        
        XCTAssertEqual(act.id, exp)
        
        act = .loaded
        exp = 1
        
        XCTAssertEqual(act.id, exp)
        
        act = .error
        exp = 2
        
        XCTAssertEqual(act.id, exp)
    }

}
