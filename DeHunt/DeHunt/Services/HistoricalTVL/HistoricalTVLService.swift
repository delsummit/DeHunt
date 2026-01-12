//
//  TVLService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation

protocol HistoricalTVLServiceProtocol {
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
}

final class HistoricalTVLService: HistoricalTVLServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await apiService.fetch(from: DefiLlamaEndpoint.historicalChainTVL.url)
    }
}
