//
//  SurveyResult.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import Foundation
import SwiftUI
import SurveyData

enum SurveyResult: Equatable {
    case success
    case failure(answer: Answer)
    
    var title: String {
        switch self {
        case .success:
            return "Success!"
        case .failure:
            return "Failure...."
        }
    }
    
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
