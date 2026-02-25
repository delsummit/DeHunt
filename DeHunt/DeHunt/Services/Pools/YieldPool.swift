//
//  YieldPool.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import Foundation
import SwiftData

struct YieldPoolResponse: Decodable {
    let status: String
    let data: [YieldPool]
}

@Model
final class YieldPool: Identifiable, Decodable {
    @Attribute(.unique) var pool: String
    var chain: String
    var project: String
    var symbol: String
    var tvlUsd: Double
    var apy: Double
    
    var id: String { pool }
    
    init(pool: String, chain: String, project: String, symbol: String, tvlUsd: Double, apy: Double) {
        self.pool = pool
        self.chain = chain
        self.project = project
        self.symbol = symbol
        self.tvlUsd = tvlUsd
        self.apy = apy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pool = try container.decode(String.self, forKey: .pool)
        self.chain = try container.decode(String.self, forKey: .chain)
        self.project = try container.decode(String.self, forKey: .project)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.tvlUsd = try container.decode(Double.self, forKey: .tvlUsd)
        self.apy = try container.decode(Double.self, forKey: .apy)
    }
    
    enum CodingKeys: String, CodingKey {
        case pool, chain, project, symbol, tvlUsd, apy
    }
}
