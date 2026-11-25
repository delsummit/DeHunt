//
//  MockAPIService.swift
//  DeHuntKit
//
//  Created by Rostyslav Mukoida on 25/11/2026.
//

import Foundation
import Synchronization
import Networking

final class MockAPIService: APIServiceProtocol {
    private let responses: [String: Data]
    private let requests = Mutex<[String]>([])

    init(responses: [String: Data]) {
        self.responses = responses
    }

    var requestedURLs: [String] {
        requests.withLock { $0 }
    }

    func fetch<T: Decodable & Sendable>(from endpoint: String) async throws -> T {
        requests.withLock { $0.append(endpoint) }
        guard let data = responses[endpoint] else {
            throw LlamaAPIError.invalidResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
