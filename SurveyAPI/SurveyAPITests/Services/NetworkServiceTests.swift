//
//  NetworkServiceTests.swift
//  SurveyAPITests
//
//  Created by Dominik Babic on 25.03.2024..
//

import XCTest
@testable import SurveyAPI
@testable import SurveyData

final class NetworkServiceTests: XCTestCase {
    
    let route = QuestionsRoute.getQuestions

    var service: NetworkService!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        let session = URLSession(configuration: config)
        
        service = NetworkService(session: session)
    }
    
    func testRequestFailure() async {
        URLProtocolMock.requestHandler = { request in
            throw NSError(domain: "Failed request", code: 0)
        }
        
        do {
            let url = try route.apiURL()
            let request = URLRequest(url: url)
            let _: Data = try await service.request(request)
            XCTFail("Request succeeded when it should have failed.")
        } catch {
            XCTAssertEqual((error as NSError).domain, "Failed request")
        }
    }
    
    func testRequestMalformedData() async {
        URLProtocolMock.requestHandler = { request in
            let jsonString = """
            [
                {
                    "id": 1
                }
            ]
            """
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: "2.0",
                                           headerFields: nil)!
            return (response, jsonString.data(using: .utf8)!)
        }
        
        do {
            let url = try route.apiURL()
            let request = URLRequest(url: url)
            let _: [Question] = try await service.request(request)
            XCTFail("Request succeeded when it should have failed.")
        } catch {
            XCTAssertNotNil(error as? DecodingError)
            
            switch error as? DecodingError {
            case .keyNotFound(let key, _):
                XCTAssertEqual(key.stringValue, "question")
            default:
                XCTFail("Found unexpected key, expected `question`.")
            }
        }
    }
    
    func testRequestSuccess() async {
        URLProtocolMock.requestHandler = { request in
            let jsonString = """
            [
                {
                    "id": 1,
                    "question": "What is your favourite food?"
                }
            ]
            """
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: "2.0",
                                           headerFields: nil)!
            return (response, jsonString.data(using: .utf8)!)
        }
        
        do {
            let url = try route.apiURL()
            let request = URLRequest(url: url)
            let data: [Question] = try await service.request(request)
            XCTAssertEqual(data[0].id, 1)
            XCTAssertEqual(data[0].question, "What is your favourite food?")
        } catch {
            XCTFail("Request failed when it should have succeeded.")
        }
    }

    func testCompletableFailure() async {
        URLProtocolMock.requestHandler = { request in
            throw NSError(domain: "Failed request", code: 0)
        }
        
        do {
            let url = try route.apiURL()
            let request = URLRequest(url: url)
            try await service.completableRequest(request)
            XCTFail("Request succeeded when it should have failed.")
        } catch {
            XCTAssertEqual((error as NSError).domain, "Failed request")
        }
    }
    
    func testCompletableSuccess() async {
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: "2.0",
                                           headerFields: nil)!
            return (response, Data())
        }
        
        do {
            let url = try route.apiURL()
            let request = URLRequest(url: url)
            try await service.completableRequest(request)
        } catch {
            XCTFail("Request failed when it should have succeeded.")
        }
    }
}
