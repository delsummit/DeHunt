//
//  DeFiAPIClient.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

// MARK: - API Client Protocol
protocol DeFiAPIClientProtocol {
    var protocols: ProtocolsServiceProtocol { get }
    var tvl: HistoricalTVLServiceProtocol { get }
    var yieldPools: YieldPoolServiceProtocol { get }
    
    func fetchProtocols() async throws -> [ProtocolsTVL]
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
    func fetchYieldPools() async throws -> [YieldPool]
}

// MARK: - API Client
final class DeFiAPIClient: DeFiAPIClientProtocol {
    
    let protocols: ProtocolsServiceProtocol
    let tvl: HistoricalTVLServiceProtocol
    let yieldPools: YieldPoolServiceProtocol
    
    init(
        protocols: ProtocolsServiceProtocol = ProtocolsService(),
        tvl: HistoricalTVLServiceProtocol = HistoricalTVLService(),
        yieldPools: YieldPoolServiceProtocol = YieldPoolService()
    ) {
        self.protocols = protocols
        self.tvl = tvl
        self.yieldPools = yieldPools
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
}
