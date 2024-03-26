//
//  SurveyViewModel.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation
import Combine
import SurveyAPI
import SurveyData
import SwiftUI

final class SurveyViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkService: NetworkServiceProtocol
    
    var maxRetries = 3
    
    @Published var errorCount = 0
    
    @Published var questions: [Question] = []
    @Published var questionsAnswered: [Int] = []
    
    @Published var index = 0
    
    @Published var answeredCount: String?
    @Published var questionIndex: String?
    
    @Published var surveyState: SurveyViewState = .loading
    @Published var surveyResult: SurveyResult?
    
    private var timer: Timer?
    private var timerInterval: TimeInterval = 3
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        setupBinding()
    }
    
    private func setupBinding() {
        $errorCount
            .map { [weak self] count in
                return count == self?.maxRetries
            }
            .sink { [weak self] value in
                if value {
                    self?.surveyState = .error
                }
            }
            .store(in: &cancellables)
        
        $questionsAnswered
            .combineLatest($questions) { "Answered \($0.count) of \($1.count)" }
            .sink { [weak self] count in
                self?.answeredCount = count
            }
            .store(in: &cancellables)
        
        $index
            .combineLatest($questions)
            .filter { !$0.1.isEmpty }
            .map { "Question \($0.0 + 1) of \($0.1.count)" }
            .sink { [weak self] count in
                self?.questionIndex = count
            }
            .store(in: &cancellables)
    }
    
    func incrementIndex() {
        guard index < questions.count - 1 else { return }
        index += 1
    }
    
    func decrementIndex() {
        guard index > 0 else { return }
        index -= 1
    }
    
    @MainActor
    func loadQuestions() async throws {
        resetErrorCount()
        
        surveyState = .loading
        
        do {
            let route = try QuestionsRoute.getQuestions.apiURL()
            let request = URLRequest(url: route)
            let data: [Question] = try await networkService.request(request)
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.questions = data.sorted { $0.id < $1.id }
            errorCount = 0
            surveyState = .loaded
        } catch let error {
            errorCount += 1
            throw error
        }
    }
    
    @MainActor
    func submit(answer: Answer) async {
        do {
            let route = try QuestionsRoute.postQuestion(answer: answer).apiURL()
            let request = URLRequest(url: route)
            try await networkService.completableRequest(request)
            questionsAnswered.append(answer.id)
            
            withAnimation {
                surveyResult = .success
            }
        } catch {
            withAnimation {
                surveyResult = .failure(answer: answer)
            }
        }
        
        setTimer()
    }
    
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] timer in
            guard let self else { return }
            
            self.resetResult()
        }
    }
    
    func resetResult() {
        stopTimer()
        
        withAnimation {
            self.surveyResult = nil
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetErrorCount() {
        if errorCount == maxRetries {
            errorCount = 0
        }
    }
}
