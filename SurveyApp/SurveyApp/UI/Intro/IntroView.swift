//
//  IntroView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import SwiftUI

struct IntroView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            logo
            
            Spacer()
            
            getStartedButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
    
    var logo: some View {
        Image("Survey")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var getStartedButton: some View {
        NavigationLink(value: SurveyAppRoute.surveyView) {
            Text("Get started")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.blue)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    IntroView()
}
