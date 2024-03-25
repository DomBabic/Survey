//
//  ApiRouteProtocol+URL.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

extension ApiRouteProtocol {
    /// Method used to format base API URL `String` into a route.
    ///
    /// - Returns:
    ///     `String` representing route for given API endpoint.
    ///
    /// - Throws: ``ApiError`` indicating that request URL formatting had failed.
    ///
    /// Method formats base API URL with given path and query parameters.
    /// Path component is appended to the base API URL, while query parameters
    /// are appended with percent encoding.
    func formattedUrlString() throws -> String {
        guard var urlString = baseURL?.appendingPathComponent(path).absoluteString else {
            throw ApiError.invalidUrl(url: baseURL?.absoluteString)
        }
        
        if let query = query {
            urlString.append("?")
            
            for (key, value) in query {
                if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    urlString.append("\(key)=\(encodedValue)&")
                }
            }
            
            if urlString.last == "&" {
                urlString = String(urlString.dropLast())
            }
        }
        
        return urlString
    }
    
    /// Method used to generate API endpoint URL.
    ///
    /// - Returns:
    ///     `URL` from formatted base API URL `String`.
    ///
    /// - Throws: ``ApiError`` indicating that URL formatting had failed.
    public func apiURL() throws -> URL {
        let urlString = try formattedUrlString()
        
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidUrl(url: urlString)
        }
        
        return url
    }
}
