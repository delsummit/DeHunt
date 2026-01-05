//
//  PoolsService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 04/01/2026.
//

import Foundation

protocol YieldPoolServiceProtocol {
    func fetchYieldPools() async throws -> [YieldPool]
}

final class YieldPoolService: YieldPoolServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchYieldPools() async throws -> [YieldPool] {
        try await apiService.fetch(from: DefiLlamaEndpoint.yieldPools.url)
    }
}
