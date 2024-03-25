//
//  QuestionsRouteTests.swift
//  SurveyAPITests
//
//  Created by Dominik Babic on 25.03.2024..
//

import XCTest
@testable import SurveyAPI
@testable import SurveyData

final class QuestionsRouteTests: XCTestCase {

    func testRoute() {
        var route = QuestionsRoute.getQuestions
        
        XCTAssertEqual(route.method, .GET)
        XCTAssertEqual(route.path, "questions")
        XCTAssertNil(route.query)
        XCTAssertTrue(route.headers.contains(where: { $0.field == .contentType }))
        XCTAssertNil(route.body)
        
        route = .postQuestion(answer: .init(id: 1, answer: ""))
        
        XCTAssertEqual(route.method, .POST)
        XCTAssertEqual(route.path, "question/submit")
        XCTAssertNil(route.query)
        XCTAssertTrue(route.headers.contains(where: { $0.field == .contentType }))
        XCTAssertNotNil(route.body)
    }
    
    func testFormattedUrlString() throws {
        var formatted = try QuestionsRoute.getQuestions.formattedUrlString()
        
        var exp = "https://xm-assignment.web.app/questions"
        var act = String(formatted.prefix(exp.count))
        
        XCTAssertEqual(act, exp)
        
        formatted = try QuestionsRoute.postQuestion(answer: .init(id: 1, answer: "")).formattedUrlString()
        
        exp = "https://xm-assignment.web.app/question/submit"
        act = String(formatted.prefix(exp.count))
        
        XCTAssertEqual(act, exp)
    }

    func testApiURL() throws {
        let url = try QuestionsRoute.getQuestions.apiURL()
        
        XCTAssertEqual(url.absoluteString, "https://xm-assignment.web.app/questions")
    }
}
