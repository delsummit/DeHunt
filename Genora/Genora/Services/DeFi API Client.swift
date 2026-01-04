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
    
    func fetchProtocols() async throws -> [ProtocolsTVL]
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
}

// MARK: - API Client
final class DeFiAPIClient: DeFiAPIClientProtocol {
    
    let protocols: ProtocolsServiceProtocol
    let tvl: HistoricalTVLServiceProtocol
    
    init(
        protocols: ProtocolsServiceProtocol = ProtocolsService(),
        tvl: HistoricalTVLServiceProtocol = HistoricalTVLService()
    ) {
        self.protocols = protocols
        self.tvl = tvl
    }
    
    func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await protocols.fetchProtocols()
    }
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await tvl.fetchHistoricalTVL()
    }
}

// MARK: - Mock API Client

final class MockDeFiAPIClient: DeFiAPIClientProtocol {
    
    let protocols: ProtocolsServiceProtocol
    let tvl: HistoricalTVLServiceProtocol
    
    init(
        protocols: ProtocolsServiceProtocol = MockProtocolsService(),
        tvl: HistoricalTVLServiceProtocol = MockHistoricalTVLService()
    ) {
        self.protocols = protocols
        self.tvl = tvl
    }
    
    func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await protocols.fetchProtocols()
    }
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await tvl.fetchHistoricalTVL()
    }
}
