//
//  HistoricalTVLService.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation
import Networking

protocol HistoricalTVLServiceProtocol: Sendable {
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
}

final class HistoricalTVLService: HistoricalTVLServiceProtocol {
    
    private let apiService: any APIServiceProtocol
    
    init(apiService: any APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVL] {
        try await apiService.fetch(from: DefiLlamaEndpoint.historicalChainTVL.url)
    }
}
