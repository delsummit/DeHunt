//
//  Mocks.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import Foundation
import Synchronization
@testable import DefiLlama

public struct MockDeFiAPIClient: DeFiAPIClientProtocol {
    public init() { }
    
    public var protocols: Result<[ProtocolsTVL], any Error> = .success([])
    public var historicalTVL: Result<[HistoricalTVL], any Error> = .success([])
    public var yieldPools: Result<[YieldPool], any Error> = .success([])
    public var poolCharts: [String: Result<[PoolChartPoint], any Error>] = [:]
    public var chartDelay: Duration = .zero
    public let chartRequests = ChartRequestLog()

    public func fetchProtocols() async throws -> [ProtocolsTVL] { try protocols.get() }

    public func fetchHistoricalTVL() async throws -> [HistoricalTVL] { try historicalTVL.get() }

    public func fetchYieldPools() async throws -> [YieldPool] { try yieldPools.get() }

    public func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint] {
        chartRequests.begin(poolId)
        defer { chartRequests.end() }
        if chartDelay > .zero {
            try await Task.sleep(for: chartDelay)
        }
        return try poolCharts[poolId]?.get() ?? []
    }
}

public final class ChartRequestLog: Sendable {
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

    public var requested: [String] { state.withLock { $0.requested } }

    public var peakInFlight: Int { state.withLock { $0.peakInFlight } }
}

extension YieldPool {
    public static func fixture(
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
    public static func fixture(
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

public struct TestError: Error {
    public init() { }
}
