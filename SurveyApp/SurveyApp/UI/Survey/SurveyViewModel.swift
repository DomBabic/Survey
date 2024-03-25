//
//  SurveyViewModel.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation
import Combine

final class SurveyViewModel: ObservableObject {
    
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
        
        setupBinding()
    }
    
    private func setupBinding() {
        
    }
}
