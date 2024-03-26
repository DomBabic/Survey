//
//  SurveyViewModelTests.swift
//  SurveyAppTests
//
//  Created by Dominik Babic on 26.03.2024..
//

import XCTest
@testable import SurveyApp

final class SurveyViewModelTests: XCTestCase {
    
    var data = """
    [
        {
            "id": 0,
            "question": "What is your favourite food?"
        },
        {
            "id": 1,
            "question": "What is your favourite sport?"
        }
    ]
    """.data(using: .utf8)
    
    var networkMock = NetworkServiceMock()
    var viewModel: SurveyViewModel!
    
    override func setUp() {
        super.setUp()
        
        networkMock.returnData = data
        
        viewModel = .init(constants: .init(retries: 1, interval: 1),
                          networkService: networkMock)
    }

    func testLoadQuestionsFailure() async {
        networkMock.shouldFail = true
        
        XCTAssertEqual(viewModel.errorCount, 0)
        XCTAssertEqual(viewModel.surveyState, .loading)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertNil(viewModel.answeredCount)
        XCTAssertNil(viewModel.questionIndex)
        
        var exp = XCTestExpectation(description: "Should fail.")
        
        do {
            try await viewModel.loadQuestions()
        } catch {
            exp.fulfill()
        }
        
        await fulfillment(of: [exp], timeout: 0.2)
        
        XCTAssertEqual(viewModel.errorCount, 1)
        XCTAssertEqual(viewModel.surveyState, .error)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertNil(viewModel.answeredCount)
        XCTAssertNil(viewModel.questionIndex)
        
        // Retry
        exp = XCTestExpectation(description: "Should fail.")
        
        do {
            try await viewModel.loadQuestions()
        } catch {
            exp.fulfill()
        }
        
        await fulfillment(of: [exp], timeout: 0.2)
        
        XCTAssertEqual(viewModel.errorCount, 1)
        XCTAssertEqual(viewModel.surveyState, .error)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertNil(viewModel.answeredCount)
        XCTAssertNil(viewModel.questionIndex)
    }
    
    func testLoadQuestionsSuccess() async {
        networkMock.shouldFail = false
        
        XCTAssertEqual(viewModel.errorCount, 0)
        XCTAssertEqual(viewModel.surveyState, .loading)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertNil(viewModel.answeredCount)
        XCTAssertNil(viewModel.questionIndex)
        
        var exp = XCTestExpectation(description: "Should succeed.")
        
        do {
            try await viewModel.loadQuestions()
            exp.fulfill()
        } catch {
            XCTFail("Failed when should have succeeded.")
        }
        
        await fulfillment(of: [exp], timeout: 0.2)
        
        XCTAssertEqual(viewModel.errorCount, 0)
        XCTAssertEqual(viewModel.surveyState, .loaded)
        XCTAssertEqual(viewModel.questions.count, 2)
        XCTAssertEqual(viewModel.answeredCount, "Answered 0 of 2")
        XCTAssertEqual(viewModel.questionIndex, "Question 1 of 2")
    }
    
    func testIndex() async {
        networkMock.shouldFail = false
        
        XCTAssertEqual(viewModel.index, 0)
        XCTAssertEqual(viewModel.questions.count, 0)
        XCTAssertNil(viewModel.questionIndex)
        
        do {
            try await viewModel.loadQuestions()
        } catch {
            XCTFail("Failed when should have succeeded.")
        }
        
        XCTAssertEqual(viewModel.index, 0)
        XCTAssertEqual(viewModel.questions.count, 2)
        XCTAssertEqual(viewModel.questionIndex, "Question 1 of 2")
        
        // Increment to last element
        viewModel.incrementIndex()
        XCTAssertEqual(viewModel.index, 1)
        XCTAssertEqual(viewModel.questionIndex, "Question 2 of 2")
        
        // No change to index, end of array
        viewModel.incrementIndex()
        XCTAssertEqual(viewModel.index, 1)
        XCTAssertEqual(viewModel.questionIndex, "Question 2 of 2")
        
        // Decrement to first element
        viewModel.decrementIndex()
        XCTAssertEqual(viewModel.index, 0)
        XCTAssertEqual(viewModel.questionIndex, "Question 1 of 2")
        
        // No change to index, start of array
        viewModel.decrementIndex()
        XCTAssertEqual(viewModel.index, 0)
        XCTAssertEqual(viewModel.questionIndex, "Question 1 of 2")
    }
    
    func testSubmitFailure() async {
        networkMock.shouldFail = true
        
        // Submit
        await viewModel.submit(answer: .init(id: 0, answer: "Test"))
        XCTAssertTrue(viewModel.questionsAnswered.isEmpty)
        XCTAssertEqual(viewModel.surveyResult, .failure(answer: .init(id: 0, answer: "Test")))
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertNil(viewModel.surveyResult)
        
        // Retry
        await viewModel.submit(answer: .init(id: 0, answer: "Test"))
        XCTAssertTrue(viewModel.questionsAnswered.isEmpty)
        XCTAssertEqual(viewModel.surveyResult, .failure(answer: .init(id: 0, answer: "Test")))
        
        viewModel.resetResult()
        
        XCTAssertNil(viewModel.surveyResult)
    }
    
    func testSubmitSuccess() async throws {
        networkMock.shouldFail = false
        
        try await viewModel.loadQuestions()
        
        // Submit
        await viewModel.submit(answer: .init(id: 0, answer: "Test"))
        XCTAssertEqual(viewModel.questionsAnswered.count, 1)
        XCTAssertEqual(viewModel.surveyResult, .success)
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        XCTAssertNil(viewModel.surveyResult)
        XCTAssertEqual(viewModel.answeredCount, "Answered 1 of 2")
    }
}
