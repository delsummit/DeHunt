//
//  TVLService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation

protocol HistoricalTVLServiceProtocol {
    func fetchHistoricalTVL() async throws -> [HistoricalTVLResponse]
}

final class HistoricalTVLService: HistoricalTVLServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVLResponse] {
        try await apiService.fetch(from: DefiLlamaEndpoint.historicalChainTVL.url)
    }
}

final class MockHistoricalTVLService: HistoricalTVLServiceProtocol {
    
    var shouldFail = false
    var mockHistoricalData: [HistoricalTVLResponse] = []
    
    func fetchHistoricalTVL() async throws -> [HistoricalTVLResponse] {
        if shouldFail {
            throw LiamaAPIError.invalidData
        }
        
        if mockHistoricalData.isEmpty {
            return Self.sampleHistoricalData
        }
        
        return mockHistoricalData
    }
    
    static let sampleHistoricalData: [HistoricalTVLResponse] = {
        let now = Date()
        return (0..<7).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -dayOffset, to: now)!
            let timestamp = Int(date.timeIntervalSince1970)
            let tvl = 50_000_000_000.0 + Double(dayOffset) * 1_000_000_000.0
            return HistoricalTVLResponse(date: timestamp, tvl: tvl)
        }
    }()
}
