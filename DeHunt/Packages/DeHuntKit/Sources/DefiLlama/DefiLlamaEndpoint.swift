//
//  DefiLlamaEndpoint.swift
//  DeHuntKit
//
//  Created by Rostyslav Mukoida on 25/12/2025. Moved to DeHuntKit package on 25/11/2026
//

import Foundation

public enum DefiLlamaEndpoint {
    case protocols
    case historicalChainTVL
    case yieldPools
    case poolChart(id: String)

    private static let apiBaseURL = "https://api.llama.fi"
    private static let yieldsBaseURL = "https://yields.llama.fi"

    var baseURL: String {
        switch self {
        case .yieldPools, .poolChart:
            return Self.yieldsBaseURL
        case .protocols, .historicalChainTVL:
            return Self.apiBaseURL
        }
    }

    var path: String {
        switch self {
        case .protocols:
            return "/protocols"
        case .historicalChainTVL:
            return "/v2/historicalChainTvl"
        case .yieldPools:
            return "/pools"
        case .poolChart(let id):
            return "/chart/\(id)"
        }
    }

    public var url: String {
        baseURL + path
    }
}
