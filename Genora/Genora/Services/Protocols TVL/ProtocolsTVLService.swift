//
//  ProtocolsService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation

protocol ProtocolsServiceProtocol {
    func fetchProtocols() async throws -> [ProtocolsTVL]
}

final class ProtocolsService: ProtocolsServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await apiService.fetch(from: DefiLlamaEndpoint.protocols.url)
    }
}

final class MockProtocolsService: ProtocolsServiceProtocol {
    
    var shouldFail = false
    var mockProtocols: [ProtocolsTVL] = []
    
    func fetchProtocols() async throws -> [ProtocolsTVL] {
        if shouldFail {
            throw LiamaAPIError.invalidData
        }
        
        if mockProtocols.isEmpty {
            return Self.sampleProtocols
        }
        
        return mockProtocols
    }
    
    static let sampleProtocols: [ProtocolsTVL] = [
        ProtocolsTVL(
            id: "1",
            name: "Aave",
            symbol: "AAVE",
            category: "Lending",
            chains: ["Ethereum", "Polygon"],
            tvl: 5_000_000_000,
            chainTvls: ["Ethereum": 4_000_000_000, "Polygon": 1_000_000_000],
            change_1d: 2.5,
            change_7d: 5.2
        ),
        ProtocolsTVL(
            id: "2",
            name: "Uniswap",
            symbol: "UNI",
            category: "Dexes",
            chains: ["Ethereum"],
            tvl: 3_500_000_000,
            chainTvls: ["Ethereum": 3_500_000_000],
            change_1d: -1.2,
            change_7d: 3.4
        )
    ]
}
