//
//  NetworkService.swift
//  SurveyAPI
//
//  Created by Dominik Babic on 25.03.2024..
//

import Foundation

/// Protocol which defines methods used for performing network requests.
public protocol NetworkServiceProtocol {
    
    /// JSONDecoder used in data decoding.
    static var decoder: JSONDecoder { get }
    
    /// Method used to perform network requests.
    ///
    /// - Parameters:
    ///     - urlRequest: URLRequest with which data task is performed.
    ///
    /// - Throws: An error indicating that something went wrong while performing a request.
    ///
    /// - Returns:
    ///     Decoded object of type conforming to `Codable` protocol.
    func request<T: Codable>(_ urlRequest: URLRequest) async throws -> T
    
    /// Method used to perform network requests without return value.
    ///
    /// - Parameters:
    ///     - urlRequest: URLRequest with which data task is performed.
    ///
    /// - Throws: An error indicating that something went wrong while performing a request.
    func completableRequest(_ urlRequest: URLRequest) async throws
}

/// Service exposing methods for performing network requests.
public final class NetworkService: NetworkServiceProtocol {
    
    /// URLSession used in performing data tasks.
    let session: URLSession
    
    /// Default initialiser for ``NetworkService`` class.
    ///
    /// - Parameters:
    ///     - session: URLSession used to perform network requests.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public func request<T: Codable>(_ urlRequest: URLRequest) async throws -> T {
        let (data, _) = try await session.data(for: urlRequest)
        let result = try NetworkService.decoder.decode(T.self, from: data)
        
        return result
    }
    
    public func completableRequest(_ urlRequest: URLRequest) async throws {
        _ = try await session.data(for: urlRequest)
        
        // Optionally handle response to confirm request was a success.
    }
}
