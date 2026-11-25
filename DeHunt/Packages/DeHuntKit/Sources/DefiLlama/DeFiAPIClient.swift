//
//  DeFiAPIClient.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

// MARK: - API Client Protocol

public protocol DeFiAPIClientProtocol: Sendable {
    func fetchProtocols() async throws -> [ProtocolsTVL]
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
    func fetchYieldPools() async throws -> [YieldPool]
    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint]
}

// MARK: - API Client

public final class DeFiAPIClient: DeFiAPIClientProtocol {

    private let protocols: any ProtocolsServiceProtocol
    private let tvl: any HistoricalTVLServiceProtocol
    private let yieldPools: any YieldPoolServiceProtocol
    private let poolCharts: any PoolChartServiceProtocol

    public convenience init() {
        self.init(protocols: ProtocolsService(), tvl: HistoricalTVLService(), yieldPools: YieldPoolService(), poolCharts: PoolChartService())
    }
    
    init(
        protocols: any ProtocolsServiceProtocol,
        tvl: any HistoricalTVLServiceProtocol,
        yieldPools: any YieldPoolServiceProtocol,
        poolCharts: any PoolChartServiceProtocol
    ) {
        self.protocols = protocols
        self.tvl = tvl
        self.yieldPools = yieldPools
        self.poolCharts = poolCharts
    }

    public func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await protocols.fetchProtocols()
    }

    public func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await tvl.fetchHistoricalTVL()
    }

    public func fetchYieldPools() async throws -> [YieldPool] {
        try await yieldPools.fetchYieldPools()
    }

    public func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint] {
        try await poolCharts.fetchPoolChart(poolId: poolId)
    }
}
