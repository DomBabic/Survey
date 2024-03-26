//
//  LoadingView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            spinner
            
            Spacer()
        }
    }
    
    var spinner: some View {
        CircleSpinnerView(lineWidth: 3)
            .frame(width: 96, height: 96)
    }
}

#Preview {
    LoadingView()
}
