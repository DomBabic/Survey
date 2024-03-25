//
//  HttpHeaderField.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Enum which defines different HTTP header fields.
public enum HttpHeaderField: String {
    /// Defines `Accept` HTTP header field.
    case accept = "Accept"
    /// Defines `Accept-Encoding` HTTP header field.
    case acceptEncoding = "Accept-Encoding"
    /// Defines `Authorization` HTTP header field.
    case authorization = "Authorization"
    /// Defines `Content-Length` HTTP header field.
    case contentLength = "Content-Length"
    /// Defines `Content-Type` HTTP header field.
    case contentType = "Content-Type"
    /// Defines `User-Agent` HTTP header field.
    case userAgent = "User-Agent"
}
