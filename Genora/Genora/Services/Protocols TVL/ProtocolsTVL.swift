//
//  ChainsService.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 17/12/2025.
//

import Foundation

// MARK: - Models
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
    
    init(
        id: String,
        name: String,
        symbol: String? = nil,
        category: String? = nil,
        chains: [String]? = nil,
        tvl: Double? = nil,
        chainTvls: [String: Double]? = nil,
        change_1d: Double? = nil,
        change_7d: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.category = category
        self.chains = chains
        self.tvl = tvl
        self.chainTvls = chainTvls
        self.change_1d = change_1d
        self.change_7d = change_7d
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try? container.decode(String.self, forKey: .symbol)
        category = try? container.decode(String.self, forKey: .category)
        chains = try? container.decode([String].self, forKey: .chains)
        tvl = try? container.decode(Double.self, forKey: .tvl)
        chainTvls = try? container.decode([String: Double].self, forKey: .chainTvls)
        change_1d = try? container.decode(Double.self, forKey: .change_1d)
        change_7d = try? container.decode(Double.self, forKey: .change_7d)
    }
}
