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
        VStack {
            questionIndex
            
            content
        }
        .onAppear {
            Task.retry(maxRetryCount: viewModel.maxRetries) {
                await viewModel.loadQuestions()
            }
        }
    }
    
    @ViewBuilder
    var questionIndex: some View {
        if let text = viewModel.questionIndex {
            Text(text)
                .font(.body)
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
    }
    
    var pager: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.questions, id: \.id) { question in
                        AnswerView(question: question)
                            .environmentObject(viewModel)
                            .containerRelativeFrame(.horizontal)
                            .id(viewModel.questions.firstIndex(where: { $0.id == question.id }))
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .onChange(of: viewModel.index, initial: false) { (_, index) in
                withAnimation {
                    reader.scrollTo(index, anchor: .center)
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
    }
}

#Preview {
    SurveyView()
}
