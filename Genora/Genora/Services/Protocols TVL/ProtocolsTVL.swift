//
//  ProtocolsTVL.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 17/12/2025.
//

import Foundation

struct ProtocolsTVL: Codable, Identifiable {
    let id: String
    let name: String
    let symbol: String?
    let category: String?
    let chains: [String]?
    let tvl: Double?
    let chainTvls: [String: Double]?
    let change_1d: Double?
    let change_7d: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case category
        case chains
        case tvl
        case chainTvls
        case change_1d
        case change_7d
    }
}
