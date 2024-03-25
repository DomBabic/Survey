//
//  Task+Retry.swift
//  SurveyApp
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

extension Task where Failure == Error {
    @discardableResult
    static func retry(priority: TaskPriority? = nil,
                      maxRetryCount: Int = 3,
                      retryDelay: TimeInterval = 1,
                      operation: @Sendable @escaping () async throws -> Success) -> Task {
        Task(priority: priority) {
            let oneSecond = TimeInterval(1_000_000_000)
            let delay = UInt64(oneSecond * retryDelay)
            
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    try await Task<Never, Never>.sleep(nanoseconds: delay)
                    continue
                }
            }
            
            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
