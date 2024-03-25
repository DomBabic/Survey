//
//  ApiRouteProtocol.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Protocol used to define API route.
public protocol ApiRouteProtocol {
    /// Defines HTTP method used for a given request.
    var method: HttpMethod { get }
    /// Defines API endpoint path.
    var path: String { get }
    /// Defines API endpoint query parameters.
    var query: QueryParameters? { get }
    /// Defines API endpoint HTTP headers.
    var headers: [HttpHeader] { get }
    /// Defines data to be sent when performing network request.
    var body: Data? { get }
}
