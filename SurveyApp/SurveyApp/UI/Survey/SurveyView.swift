//
//  SurveyView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import SwiftUI
import SurveyData

struct SurveyView: View {
    
    @StateObject var viewModel: SurveyViewModel = .init()
    
    var body: some View {
        VStack {
            answeredCount
            
            content
        }
        .navigationTitle(viewModel.questionIndex ?? "Survey")
        .onAppear {
            Task.retry(maxRetryCount: viewModel.maxRetries) {
                await viewModel.loadQuestions()
            }
        }
    }
    
    @ViewBuilder
    var answeredCount: some View {
        if let text = viewModel.answeredCount {
            Text(text)
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white)
        }
    }
    
    var content: some View {
        HStack {
            previousButton
            
            pager
            
            nextButton
        }
    }
    
    var previousButton: some View {
        Button {
            viewModel.decrementIndex()
        } label: {
            Image(systemName: "chevron.compact.left")
                .resizable()
                .frame(width: 24, height: 48)
        }
        .disabled(viewModel.index == 0)
        .tint(viewModel.index == 0 ? Color.gray : Color.black)
        .padding(.leading, 8)
    }
    
    var pager: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.questions, id: \.id) { question in
                        AnswerView(question: question)
                            .environmentObject(viewModel)
                            .containerRelativeFrame(.horizontal)
                            .id(question.question)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onChange(of: viewModel.index, initial: false) { (_, index) in
                withAnimation {
                    guard viewModel.questions.indices.contains(index) else {
                        return
                    }
                    
                    let question = viewModel.questions[index]
                    
                    reader.scrollTo(question.question, anchor: .center)
                }
            }
        }
    }
    
    var nextButton: some View {
        Button {
            viewModel.incrementIndex()
        } label: {
            Image(systemName: "chevron.compact.right")
                .resizable()
                .frame(width: 24, height: 48)
        }
        .disabled(viewModel.index == viewModel.questions.count - 1)
        .tint(viewModel.index == viewModel.questions.count - 1 ? Color.gray : Color.black)
        .padding(.trailing, 8)
    }
}

#Preview {
    SurveyView()
}
