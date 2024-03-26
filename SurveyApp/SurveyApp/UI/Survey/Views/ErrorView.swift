//
//  ErrorView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import SwiftUI

struct ErrorView: View {
    
    var onError: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            titleText
            
            retryButton
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var titleText: some View {
        Text("Something went wrong.")
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    var retryButton: some View {
        Button(action: onError) {
            HStack(spacing: 4) {
                Text("Retry")
                    .font(.callout)
                
                Image(systemName: "arrow.triangle.2.circlepath")
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue.opacity(0.1))
        .clipShape(Capsule())
        .contentShape(Rectangle())
    }
}

#Preview {
    ErrorView {
        
    }
}
