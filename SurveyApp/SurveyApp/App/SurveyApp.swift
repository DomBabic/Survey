//
//  SurveyApp.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import SwiftUI

@main
struct SurveyApp: App {
    
    var body: some Scene {
        WindowGroup {
            IntroView()
                .navigation(route: SurveyAppRoute.self)
        }
    }
}
