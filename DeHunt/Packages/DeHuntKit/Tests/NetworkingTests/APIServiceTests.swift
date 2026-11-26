//
//  APIServiceTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import Foundation
import Testing
@testable import Networking

@Suite(.serialized)
struct APIServiceTests {

    private let endpoint = "https://yields.llama.fi/pools"

    private func makeSUT() -> APIService {
        APIService(session: StubURLProtocol.makeSession())
    }

    @Test func decodesSuccessfulResponse() async throws {
        StubURLProtocol.respond(status: 200, body: Data(json: """
        {"status": "success", "data": [
          {"pool": "p1", "chain": "Ethereum", "project": "lido", "symbol": "STETH",
           "tvlUsd": 21720072173, "apy": 2.25, "apyBase": 2.25, "apyReward": null}
        ]}
        """))

        let response: Payload = try await makeSUT().fetch(from: endpoint)

        #expect(response.data == [
            Payload.Pool(pool: "p1", apy: 2.25)
        ])
    }

    @Test func requestsTheGivenURL() async throws {
        var requestedURL: URL?
        StubURLProtocol.handler = { request in
            requestedURL = request.url
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(json: #"{"status": "success", "data": []}"#))
        }

        let _: Payload = try await makeSUT().fetch(from: endpoint)

        #expect(requestedURL?.absoluteString == endpoint)
    }

    @Test func non200StatusThrowsInvalidResponse() async {
        StubURLProtocol.respond(status: 500, body: Data(json: #"{"status": "success", "data": []}"#))

        let error = await fetchError(Payload.self)

        #expect(error as? LlamaAPIError == .invalidResponse)
    }

    @Test func malformedJSONThrowsInvalidData() async {
        StubURLProtocol.respond(status: 200, body: Data(json: #"{"status": "success", "data": [{"pool": 1}]}"#))

        let error = await fetchError(Payload.self)

        #expect(error as? LlamaAPIError == .invalidData)
    }

    @Test func emptyEndpointThrowsInvalidURL() async {
        let error = await fetchError(Payload.self, endpoint: "")

        #expect(error as? LlamaAPIError == .invalidURL)
    }

    @Test func networkErrorIsPassedThrough() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }

        let error = await fetchError(Payload.self)

        #expect((error as? URLError)?.code == .notConnectedToInternet)
    }

    @MainActor @Test
    func decodesOffTheMainThreadWhenCalledFromMainActor() async throws {
        StubURLProtocol.respond(status: 200, body: Data(json: "{}"))

        let probe: ThreadProbe = try await makeSUT().fetch(from: endpoint)

        #expect(!probe.decodedOnMainThread)
    }

    private func fetchError<T: Decodable & Sendable>(_ type: T.Type, endpoint: String? = nil) async -> (any Error)? {
        do {
            let _: T = try await makeSUT().fetch(from: endpoint ?? self.endpoint)
            Issue.record("Expected fetch to throw")
            return nil
        } catch {
            return error
        }
    }
}

private struct ThreadProbe: Decodable, Sendable {
    let decodedOnMainThread: Bool

    init(from decoder: any Decoder) throws {
        decodedOnMainThread = Thread.isMainThread
    }
}

private struct Payload: Decodable, Sendable, Equatable {
    let status: String
    let data: [Pool]

    struct Pool: Decodable, Sendable, Equatable {
        let pool: String
        let apy: Double
    }
}

extension Data {
    init(json: String) {
        self = Data(json.utf8)
    }
}
