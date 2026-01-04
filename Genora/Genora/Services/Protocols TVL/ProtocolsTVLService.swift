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
