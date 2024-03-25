//
//  SurveyAppRoute.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation
import SwiftUI

enum SurveyAppRoute: Hashable, View {
    case surveyView
    
    var body: some View {
        switch self {
        case .surveyView:
            SurveyView()
        }
    }
}
