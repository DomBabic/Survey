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

/// ViewModel used to setup `SurveyView` UI.
///
/// When loaded, `SurveyView` will instruct `SurveyViewModel` to fetch the data from the API.
/// Depending on the outcome, `SurveyView` will show appropriate View state.
final class SurveyViewModel: ObservableObject {
    
    /// Data model used to inject common constants.
    ///
    /// By injecting Constants object into VM, unit test environment can be controlled.
    /// Making it easier to override default values and speed up testing.
    struct Constants {
        /// Represents maximum number of retries that will be performed in case of request failure.
        let retries: Int
        /// Represents time that toast will be displayed in View after submitting an answer.
        let interval: TimeInterval
        
        /// Default initialiser for Constants struct.
        init(retries: Int = 3, interval: TimeInterval = 3) {
            self.retries = retries
            self.interval = interval
        }
    }
    
    /// Set used to store bindings.
    private var cancellables = Set<AnyCancellable>()
    
    /// Service responsible for performing network requests.
    var networkService: NetworkServiceProtocol
    
    /// Represents maximum number of retries that will be performed in case of request failure.
    var maxRetries: Int
    /// Represents time that toast will be displayed in View after submitting an answer.
    var timerInterval: TimeInterval
    
    /// Represents a number of times an error has occurred when performing network request for loading questions data.
    @Published var errorCount = 0
    
    /// Array of Question object used to layout the `SurveyView`.
    @Published var questions: [Question] = []
    /// Array of integers representing ID of answered questions.
    @Published var questionsAnswered: [Int] = []
    
    /// Integer representing current question index.
    @Published var index = 0
    
    /// String, if any, representing current question index of total number of questions.
    @Published var answeredCount: String?
    /// String, if any, representing number of answered questions of total number of questions.
    @Published var questionIndex: String?
    
    /// Enum case representing current `SurveyView` state.
    @Published var surveyState: SurveyViewState = .loading
    /// Enum case representing the result of submitting answer to the question.
    @Published var surveyResult: SurveyResult?
    
    /// Timer used to dismiss toast displayed after submitting an answer.
    private var timer: Timer?
    
    /// Default initialiser for `SurveyViewModel` class.
    ///
    /// - Parameters:
    ///     - constants: Constants object containing values used for retry mechanism and toast display.
    ///     - networkService: Service used to perform network requests.
    init(constants: Constants = .init(),
         networkService: NetworkServiceProtocol = NetworkService()) {
        self.maxRetries = constants.retries
        self.timerInterval = constants.interval
        self.networkService = networkService
        
        setupBinding()
    }
    
    /// Method used to setup publisher binding.
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
            .combineLatest($questions)
            .filter { !$0.1.isEmpty }
            .map { "Answered \($0.0.count) of \($0.1.count)" }
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
    
    /// Method used to increment current index, resulting in user being navigated to the next page.
    ///
    /// If it is not possible to inrement index, nothing happens.
    func incrementIndex() {
        guard index < questions.count - 1 else { return }
        index += 1
    }
    
    /// Method used to decrement current index, resulting in user being navigated to the previous page.
    ///
    /// If it is not possible to decrement index, nothing happens.
    func decrementIndex() {
        guard index > 0 else { return }
        index -= 1
    }
    
    /// Method used to load Question data from the API.
    ///
    /// - Throws: An error indicating that request had failed, used to trigger retry mechanism.
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
    
    /// Method used to submit an `Answer` to a `Question`.
    ///
    /// - Parameters:
    ///     - answer: `Answer` object with `id` pointing to an associated `Question`,  and `answer` field containing user input.
    ///
    /// Upon completion `surveyResult` is set to indicate the outcome of performing network request - success or failure.
    /// Timer is scheduled to clear out `surveyResult` after `timerInterval` has elapsed.
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
    
    /// Method used to set timer for reseting `surveyResult`.
    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: false) { [weak self] timer in
            guard let self else { return }
            
            self.resetResult()
        }
    }
    
    /// Method used to reset `timer` and `surveyResult`.
    func resetResult() {
        stopTimer()
        
        withAnimation {
            self.surveyResult = nil
        }
    }
    
    /// Method used to invalidate `timer` and remove it.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Method used to reset `errorCount` when `maxRetries` count has been reached.
    private func resetErrorCount() {
        if errorCount == maxRetries {
            errorCount = 0
        }
    }
}
