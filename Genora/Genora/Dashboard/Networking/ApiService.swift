//
//  ApiService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 17/12/2025.
//

import Foundation

class ChainsService {
    static let shared = ChainsService()
    private init() { }
    
    func fetchChains() async throws -> [ProtocolsTVL] {
        let endpoint = "https://api.llama.fi/protocols"
        
        guard let url = URL(string: endpoint) else {
            throw LiamaAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw LiamaAPIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ProtocolsTVL].self, from: data)
        } catch {
            throw LiamaAPIError.invalidData
        }
    }
}

enum LiamaAPIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
