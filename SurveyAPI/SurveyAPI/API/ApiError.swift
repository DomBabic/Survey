//
//  ApiError.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// API error enum used to notify of an issue
public enum ApiError: Error {
    /// Indicates that URL is invalid.
    case invalidUrl(url: String?)
    /// Indicates that data is malformed.
    case malformedData(data: Data)
}
