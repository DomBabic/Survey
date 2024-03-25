//
//  Question.swift
//  SurveyData
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Data model used to decode API response for the questions route.
public struct Question: Codable {
    /// Int representing the question identifier.
    public let id: Int
    /// String representing the question.
    public let question: String
    
    enum CodingKeys: String, CodingKey {
        case id, question
    }
}
