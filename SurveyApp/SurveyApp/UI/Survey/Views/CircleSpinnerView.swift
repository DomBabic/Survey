//
//  CircleSpinnerView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 26.03.2024..
//

import SwiftUI

struct CircleSpinnerView: View {

    @State private var isAnimating = true
    @State private var animateStart = false
    @State private var animateEnd = true
    
    var strokeColor: Color = .gray.opacity(0.5)
    var fillColor: Color = .blue
    
    var lineWidth: Double = 1.5
    
    var body: some View {
        ZStack {
            baseCircle
                
            animatedCircle
        }
    }
    
    var baseCircle: some View {
        Circle()
            .stroke(strokeColor, lineWidth: lineWidth)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var animatedCircle: some View {
        Circle()
            .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
            .stroke(fillColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(isAnimating ? 0 : 360))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation(animation
                    .repeatForever(autoreverses: false)) {
                        self.isAnimating.toggle()
                    }
                withAnimation(animation
                    .delay(0.5)
                    .repeatForever(autoreverses: true)) {
                        self.animateStart.toggle()
                    }
                withAnimation(animation
                    .delay(1)
                    .repeatForever(autoreverses: true)) {
                        self.animateEnd.toggle()
                    }
            }
    }
    
    private var animation: Animation {
        Animation.linear(duration: 1)
    }
}

#Preview {
    CircleSpinnerView()
}
