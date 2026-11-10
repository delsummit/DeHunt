//
//  DeFiAPIClient.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

// MARK: - API Client Protocol

nonisolated protocol DeFiAPIClientProtocol: Sendable {
    func fetchProtocols() async throws -> [ProtocolsTVL]
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
    func fetchYieldPools() async throws -> [YieldPool]
    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint]
}

// MARK: - API Client

nonisolated final class DeFiAPIClient: DeFiAPIClientProtocol {

    private let protocols: any ProtocolsServiceProtocol
    private let tvl: any HistoricalTVLServiceProtocol
    private let yieldPools: any YieldPoolServiceProtocol
    private let poolCharts: any PoolChartServiceProtocol

    init(
        protocols: any ProtocolsServiceProtocol = ProtocolsService(),
        tvl: any HistoricalTVLServiceProtocol = HistoricalTVLService(),
        yieldPools: any YieldPoolServiceProtocol = YieldPoolService(),
        poolCharts: any PoolChartServiceProtocol = PoolChartService()
    ) {
        self.protocols = protocols
        self.tvl = tvl
        self.yieldPools = yieldPools
        self.poolCharts = poolCharts
    }

    func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await protocols.fetchProtocols()
    }

    func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await tvl.fetchHistoricalTVL()
    }

    func fetchYieldPools() async throws -> [YieldPool] {
        try await yieldPools.fetchYieldPools()
    }

    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint] {
        try await poolCharts.fetchPoolChart(poolId: poolId)
    }
}
