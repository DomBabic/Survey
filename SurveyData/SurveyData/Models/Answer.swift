//
//  Answer.swift
//  SurveyData
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Data model used to encode user's answers for POST requests to questions API.
public struct Answer: Codable {
    /// Int representing the question identifier.
    public let id: Int
    /// String representing the answer to the question with `id`.
    public let answer: String
    
    public init(id: Int, answer: String) {
        self.id = id
        self.answer = answer
    }
    
    enum CodingKeys: String, CodingKey {
        case id, answer
    }
}
