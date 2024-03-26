//
//  SurveyViewState.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import Foundation

enum SurveyViewState: Int, Identifiable {
    case loading = 0
    case loaded
    case error
    
    var id: Int { rawValue }
}
