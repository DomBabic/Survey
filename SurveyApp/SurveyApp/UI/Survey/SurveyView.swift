//
//  SurveyView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import SwiftUI

struct SurveyView: View {
    
    @StateObject var viewModel: SurveyViewModel = .init()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SurveyView()
}
