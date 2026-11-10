//
//  Mocks.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import Foundation
import Synchronization
@testable import DeHunt

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

struct MockDeFiAPIClient: DeFiAPIClientProtocol {
    var protocols: Result<[ProtocolsTVL], any Error> = .success([])
    var historicalTVL: Result<[HistoricalTVL], any Error> = .success([])
    var yieldPools: Result<[YieldPool], any Error> = .success([])
    var poolCharts: [String: Result<[PoolChartPoint], any Error>] = [:]
    var chartDelay: Duration = .zero
    let chartRequests = ChartRequestLog()

    func fetchProtocols() async throws -> [ProtocolsTVL] { try protocols.get() }

    func fetchHistoricalTVL() async throws -> [HistoricalTVL] { try historicalTVL.get() }

    func fetchYieldPools() async throws -> [YieldPool] { try yieldPools.get() }

    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint] {
        chartRequests.begin(poolId)
        defer { chartRequests.end() }
        if chartDelay > .zero {
            try await Task.sleep(for: chartDelay)
        }
        return try poolCharts[poolId]?.get() ?? []
    }
}

final class ChartRequestLog: Sendable {
    private struct State {
        var requested: [String] = []
        var inFlight = 0
        var peakInFlight = 0
    }

    private let state = Mutex(State())

    func begin(_ poolId: String) {
        state.withLock {
            $0.requested.append(poolId)
            $0.inFlight += 1
            $0.peakInFlight = max($0.peakInFlight, $0.inFlight)
        }
    }

    func end() {
        state.withLock { $0.inFlight -= 1 }
    }

    var requested: [String] { state.withLock { $0.requested } }

    var peakInFlight: Int { state.withLock { $0.peakInFlight } }
}

extension YieldPool {
    static func fixture(
        id: String = "pool-1",
        chain: String = "Ethereum",
        project: String = "aave-v3",
        symbol: String = "USDC",
        tvlUsd: Double = 1_000_000,
        apy: Double = 12
    ) -> YieldPool {
        YieldPool(pool: id, chain: chain, project: project, symbol: symbol, tvlUsd: tvlUsd, apy: apy)
    }
}

extension ProtocolsTVL {
    static func fixture(
        id: String = "1",
        name: String = "Aave",
        category: String? = "Lending",
        chains: [String]? = ["Ethereum"],
        tvl: Double? = 50_000_000,
        change1d: Double? = 1
    ) -> ProtocolsTVL {
        ProtocolsTVL(
            id: id, name: name, symbol: nil, category: category, chains: chains,
            tvl: tvl, chainTvls: nil, change_1d: change1d, change_7d: nil
        )
    }
}

struct TestError: Error {}

extension Data {
    init(json: String) {
        self = Data(json.utf8)
    }
}
