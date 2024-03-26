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
        ZStack {
            VStack {
                answeredCount
                
                content
            }
            
            toastHolder
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
    
    var toastHolder: some View {
        VStack {
            toast
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var toast: some View {
        if let result = viewModel.surveyResult {
            HStack {
                Text(result.title)
                    .font(.callout)
                    .foregroundStyle(Color.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if case .failure(let answer) = result {
                    Button {
                        viewModel.resetResult()
                        
                        Task {
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                            
                            await viewModel.submit(answer: answer)
                            
                            resignResponder()
                        }
                    } label: {
                        Text("Retry")
                            .underline()
                            .font(.callout)
                            .foregroundStyle(Color.white)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 12)
            .frame(minHeight: 50)
            .background(result.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .padding(.bottom, 4)
            .animation(.easeInOut(duration: 0.5), value: viewModel.surveyResult)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private func resignResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

#Preview {
    SurveyView()
}
