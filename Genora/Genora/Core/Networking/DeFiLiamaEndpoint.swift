//
//  APIEndpoints.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 25/12/2025.
//

import Foundation

enum DefiLlamaEndpoint {
    case protocols
    case historicalChainTVL
    
    private static let baseURL = "https://api.llama.fi"
    
    var path: String {
        switch self {
        case .protocols:
            return "/protocols"
        case .historicalChainTVL:
            return "/v2/historicalChainTvl"
        }
    }
    
    var url: String {
        Self.baseURL + path
    }
    
    func url(with queryItems: [String: String]? = nil) -> String {
        guard let queryItems = queryItems, !queryItems.isEmpty else {
            return url
        }
        
        var components = URLComponents(string: url)
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url?.absoluteString ?? url
    }
}

extension DefiLlamaEndpoint {
    var urlValue: URL? {
        URL(string: url)
    }
    
    func urlValue(with queryItems: [String: String]? = nil) -> URL? {
        URL(string: url(with: queryItems))
    }
}
