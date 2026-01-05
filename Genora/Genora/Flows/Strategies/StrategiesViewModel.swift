//
//  StrategiesViewModel.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 04/01/2026.
//

import SwiftUI

@Observable
@MainActor
final class StrategiesViewModel {
    var yields: [YieldPool] = []
    var isLoading = false
    var errorMessage: String?
    
    private let apiClient: DeFiAPIClientProtocol
    
    init(apiClient: DeFiAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    convenience init() {
        self.init(apiClient: DeFiAPIClient())
    }
    
    func loadYieldPools() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            yields = try await apiClient.fetchYieldPools()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
