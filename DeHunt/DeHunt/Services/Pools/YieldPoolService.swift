//
//  YieldPoolService.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 04/01/2026.
//

import Foundation

nonisolated protocol YieldPoolServiceProtocol: Sendable {
    func fetchYieldPools() async throws -> [YieldPool]
}

nonisolated final class YieldPoolService: YieldPoolServiceProtocol {
    
    private let apiService: any APIServiceProtocol
    
    init(apiService: any APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchYieldPools() async throws -> [YieldPool] {
        let response: YieldPoolResponse = try await apiService.fetch(from: DefiLlamaEndpoint.yieldPools.url)
        return response.data
    }
}
