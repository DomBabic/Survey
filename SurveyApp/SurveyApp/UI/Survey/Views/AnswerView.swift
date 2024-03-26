//
//  AnswerView.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import SwiftUI
import SurveyData

struct AnswerView: View {
    
    @EnvironmentObject var viewModel: SurveyViewModel
    
    @FocusState var focused: Bool
    
    var question: Question
    
    var id: Int {
        question.id
    }
    
    var didSubmit: Bool {
        viewModel.questionsAnswered.contains(id)
    }
    
    @State var answer = ""
    
    var body: some View {
        VStack(spacing: 24) {
            titleText
            
            inputField
            
            Spacer()
            
            submitButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 8)
    }
    
    var titleText: some View {
        Text(question.question)
            .font(.title)
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    var inputField: some View {
        TextField(didSubmit ? "Answer submitted!" : "Type an answer...", text: $answer, axis: .vertical)
            .font(.body)
            .foregroundStyle(Color.black)
            .padding(.all, 8)
            .background(inputBorder)
            .disabled(didSubmit)
            .padding(.horizontal, 1)
            .focused($focused)
    }
    
    var inputBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.black, lineWidth: 1)
    }
    
    var submitButton: some View {
        Button {
            Task {
                await viewModel.submit(answer: .init(id: id, answer: answer))
            }
            
            focused = false
        } label: {
            submitText
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(didSubmit ? Color.gray.opacity(0.5) : Color.blue)
        .clipShape(Capsule())
        .contentShape(Rectangle())
        .disabled(didSubmit)
    }
    
    var submitText: some View {
        Text(didSubmit ? "Already submitted" : "Submit")
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
            .foregroundStyle(Color.white)
    }
}

#Preview {
    AnswerView(question: .init(id: 1, question: "What is your favourite food?"))
        .environmentObject(SurveyViewModel())
}
