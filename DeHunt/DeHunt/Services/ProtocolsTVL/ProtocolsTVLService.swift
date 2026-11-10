//
//  ProtocolsTVLService.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation

nonisolated protocol ProtocolsServiceProtocol: Sendable {
    func fetchProtocols() async throws -> [ProtocolsTVL]
}

nonisolated final class ProtocolsService: ProtocolsServiceProtocol {
    
    private let apiService: any APIServiceProtocol
    
    init(apiService: any APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchProtocols() async throws -> [ProtocolsTVL] {
        try await apiService.fetch(from: DefiLlamaEndpoint.protocols.url)
    }
}
