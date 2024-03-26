//
//  SurveyResult.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import Foundation
import SwiftUI
import SurveyData

/// Enum used to indicate outcome of perform network requests when submitting answers to questions.
enum SurveyResult: Equatable {
    /// Represents a success state, when network request was completed without an error.
    case success
    /// Represents a failure state, when network request was completed with an error. Contains `Answer` associated value.
    case failure(answer: Answer)
    
    /// String used as title for the toast displayed in the UI.
    var title: String {
        switch self {
        case .success:
            return "Success!"
        case .failure:
            return "Failure...."
        }
    }
    
    /// Color used for the toast background.
    var background: Color {
        switch self {
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
    
    static func == (_ lhs: SurveyResult, _ rhs: SurveyResult) -> Bool {
        switch (lhs, rhs) {
        case (.failure(let lhsAnswer), .failure(let rhsAnswer)):
            return lhsAnswer.id == rhsAnswer.id
        default:
            return lhs.title == rhs.title
        }
    }
}
