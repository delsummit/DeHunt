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
    
    static let sampleProtocols: [ProtocolsTVL] = {
        let json = """
        [
            {
                "id": "1",
                "name": "Aave",
                "symbol": "AAVE",
                "category": "Lending",
                "chains": ["Ethereum", "Polygon"],
                "tvl": 5000000000,
                "chainTvls": {"Ethereum": 4000000000, "Polygon": 1000000000},
                "change_1d": 2.5,
                "change_7d": 5.2
            },
            {
                "id": "2",
                "name": "Uniswap",
                "symbol": "UNI",
                "category": "Dexes",
                "chains": ["Ethereum"],
                "tvl": 3500000000,
                "chainTvls": {"Ethereum": 3500000000},
                "change_1d": -1.2,
                "change_7d": 3.4
            }
        ]
        """
        
        guard let data = json.data(using: .utf8),
              let protocols = try? JSONDecoder().decode([ProtocolsTVL].self, from: data) else {
            return []
        }
        
        return protocols
    }()
}
