//
//  NetworkServiceMock.swift
//  SurveyAppTests
//
//  Created by Dominik Babic on 26.03.2024..
//

import Foundation
import SurveyAPI

final class NetworkServiceMock: NetworkServiceProtocol {
    static var decoder = JSONDecoder()
    
    var shouldFail = false
    var returnData: Data?
    
    func request<T>(_ urlRequest: URLRequest) async throws -> T where T : Decodable, T : Encodable {
        guard !shouldFail, let data = returnData else {
            throw ApiError.malformedData(data: Data())
        }
        
        return try NetworkServiceMock.decoder.decode(T.self, from: data)
    }
    
    func completableRequest(_ urlRequest: URLRequest) async throws {
        if shouldFail {
            throw ApiError.malformedData(data: Data())
        }
    }
}
