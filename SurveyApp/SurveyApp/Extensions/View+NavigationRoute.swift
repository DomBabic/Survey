//
//  View+NavigationRoute.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation
import SwiftUI

extension View {
    func navigation<Route: Hashable & View>(route: Route.Type) -> some View {
        NavigationStack {
            self.navigationDestination(for: route.self, destination: { $0 })
        }
    }
}
