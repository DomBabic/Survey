//
//  QuestionsRoute.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation
import SurveyData

/// Route used to fetch questions and post question answers.
enum QuestionsRoute: ApiRouteProtocol {
    
    /// JSONEncoder used to encode body data.
    static let encoder = JSONEncoder()
    
    /// Route used when fetching questions data.
    case getQuestions
    /// Route used when posting question answer.
    case postQuestion(answer: Answer)
    
    var method: HttpMethod {
        switch self {
        case .getQuestions:
            return .GET
        case .postQuestion:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .getQuestions:
            return "questions"
        case .postQuestion:
            return "question/submit"
        }
    }
    
    var query: QueryParameters? { nil }
    
    var headers: [HttpHeader] {
        return defaultHeaders
    }
    
    var body: Data? {
        switch self {
        case .getQuestions:
            return nil
        case .postQuestion(let answer):
            return try? QuestionsRoute.encoder.encode(answer)
        }
    }
}
