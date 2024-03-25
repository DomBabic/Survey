//
//  ApiRouteProtocol+Defaults.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

extension ApiRouteProtocol {
    
    /// Base API URL.
    var baseURL: URL? {
        URL(string: ApiConstants.baseUrl)
    }
    
    /// Default query parameters used in every network request.
    var defaultQueryParameters: QueryParameters {
        [:]
    }
    
    /// Default HTTP header fields used in every network request.
    var defaultHeaders: [HttpHeader] {
        var basicHeaders: [HttpHeader] = [
            .init(field: .contentType, value: MimeType.json.rawValue)
        ]
        
        if body == nil {
            basicHeaders.append(.init(field: .contentLength, value: "0"))
        }
        
        return basicHeaders
    }
}
