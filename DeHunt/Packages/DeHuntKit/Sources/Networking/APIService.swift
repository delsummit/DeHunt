//
//  APIService.swift
//  DeHuntKit
//
//  Created by Rostyslav Mukoida on 17/12/2025. Moved to DeHuntKit on 24/11/2026
//

import Foundation

public protocol APIServiceProtocol: Sendable {
    func fetch<T: Decodable & Sendable>(from endpoint: String) async throws -> T
}

public final class APIService: APIServiceProtocol {
    public static let shared = APIService()

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetch<T: Decodable & Sendable>(from endpoint: String) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw LlamaAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw LlamaAPIError.invalidResponse
        }

        return try await Self.decode(T.self, from: data)
    }

    @concurrent
    private static func decode<T: Decodable & Sendable>(_ type: T.Type, from data: Data) async throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw LlamaAPIError.invalidData
        }
    }
}

public enum LlamaAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
