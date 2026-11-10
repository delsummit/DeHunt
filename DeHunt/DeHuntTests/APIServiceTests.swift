//
//  APIServiceTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

final class APIServiceTests: XCTestCase {

    private let endpoint = "https://yields.llama.fi/pools"

    override func tearDown() {
        StubURLProtocol.handler = nil
        super.tearDown()
    }

    private func makeSUT() -> APIService {
        APIService(session: StubURLProtocol.makeSession())
    }

    func testDecodesSuccessfulResponse() async throws {
        StubURLProtocol.respond(status: 200, body: Data(json: """
        {"status": "success", "data": [
          {"pool": "p1", "chain": "Ethereum", "project": "lido", "symbol": "STETH",
           "tvlUsd": 21720072173, "apy": 2.25, "apyBase": 2.25, "apyReward": null}
        ]}
        """))

        let response: YieldPoolResponse = try await makeSUT().fetch(from: endpoint)

        XCTAssertEqual(response.data, [
            YieldPool(pool: "p1", chain: "Ethereum", project: "lido", symbol: "STETH", tvlUsd: 21720072173, apy: 2.25)
        ])
    }

    func testRequestsTheGivenURL() async throws {
        var requestedURL: URL?
        StubURLProtocol.handler = { request in
            requestedURL = request.url
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(json: #"{"status": "success", "data": []}"#))
        }

        let _: YieldPoolResponse = try await makeSUT().fetch(from: endpoint)

        XCTAssertEqual(requestedURL?.absoluteString, endpoint)
    }

    func testNon200StatusThrowsInvalidResponse() async {
        StubURLProtocol.respond(status: 500, body: Data(json: #"{"status": "success", "data": []}"#))

        let error = await fetchError(YieldPoolResponse.self)

        XCTAssertEqual(error as? LlamaAPIError, .invalidResponse)
    }

    func testMalformedJSONThrowsInvalidData() async {
        StubURLProtocol.respond(status: 200, body: Data(json: #"{"status": "success", "data": [{"pool": 1}]}"#))

        let error = await fetchError(YieldPoolResponse.self)

        XCTAssertEqual(error as? LlamaAPIError, .invalidData)
    }

    func testEmptyEndpointThrowsInvalidURL() async {
        let error = await fetchError(YieldPoolResponse.self, endpoint: "")

        XCTAssertEqual(error as? LlamaAPIError, .invalidURL)
    }

    func testNetworkErrorIsPassedThrough() async {
        StubURLProtocol.handler = { _ in throw URLError(.notConnectedToInternet) }

        let error = await fetchError(YieldPoolResponse.self)

        XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
    }

    @MainActor
    func testDecodesOffTheMainThreadWhenCalledFromMainActor() async throws {
        StubURLProtocol.respond(status: 200, body: Data(json: "{}"))

        let probe: ThreadProbe = try await makeSUT().fetch(from: endpoint)

        XCTAssertFalse(probe.decodedOnMainThread)
    }

    private func fetchError<T: Decodable & Sendable>(_ type: T.Type, endpoint: String? = nil) async -> (any Error)? {
        do {
            let _: T = try await makeSUT().fetch(from: endpoint ?? self.endpoint)
            XCTFail("Expected fetch to throw")
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
