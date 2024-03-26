//
//  SurveyViewState.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import Foundation

/// Enum used to setup `SurveyView` UI based on the result of network requests.
enum SurveyViewState: Int, Identifiable {
    /// Represents the state where network request is still being performed.
    case loading = 0
    /// Represents the state where network request was completed successfully and data can be displayed.
    case loaded
    /// Represents the state where network request exceeded maximum retry count.
    case error
    
    /// State identifier, equal to `rawValue` of the case.
    var id: Int { rawValue }
}
