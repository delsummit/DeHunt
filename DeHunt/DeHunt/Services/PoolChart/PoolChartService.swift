//
//  PoolChartService.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 09/11/2026.
//

import Foundation

nonisolated protocol PoolChartServiceProtocol: Sendable {
    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint]
}

nonisolated final class PoolChartService: PoolChartServiceProtocol {

    private let apiService: any APIServiceProtocol

    init(apiService: any APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func fetchPoolChart(poolId: String) async throws -> [PoolChartPoint] {
        let response: PoolChartResponse = try await apiService.fetch(from: DefiLlamaEndpoint.poolChart(id: poolId).url)
        return response.data
    }
}
