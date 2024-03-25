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

final class SurveyViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkService: NetworkServiceProtocol
    
    var maxRetries = 3
    
    @Published var questions: [Question] = []
    @Published var questionsAnswered: [Int] = []
    
    @Published var errorCount = 0
    @Published var errorShown = false
    
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
                self?.errorShown = value
            }
            .store(in: &cancellables)
        
    }
    
    @MainActor
    func loadQuestions() async {
        resetErrorCount()
        
        do {
            let route = try QuestionsRoute.getQuestions.apiURL()
            let request = URLRequest(url: route)
            let data: [Question] = try await networkService.request(request)
            self.questions = data.sorted { $0.id < $1.id }
            errorCount = 0
        } catch {
            errorCount += 1
        }
    }
    
    @MainActor
    func submit(answer: Answer) async {
        resetErrorCount()
        
        do {
            let route = try QuestionsRoute.postQuestion(answer: answer).apiURL()
            let request = URLRequest(url: route)
            try await networkService.completableRequest(request)
            questionsAnswered.append(answer.id)
            errorCount = 0
        } catch {
            errorCount += 1
        }
    }
    
    private func resetErrorCount() {
        if errorCount == maxRetries {
            errorCount = 0
        }
    }
}
