//
//  YieldPool.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import Foundation

public struct YieldPoolResponse: Decodable, Sendable {
    let status: String
    public let data: [YieldPool]
}

public struct YieldPool: Identifiable, Hashable, Decodable, Sendable {
    public let pool: String
    public let chain: String
    public let project: String
    public let symbol: String
    public let tvlUsd: Double
    public let apy: Double

    public var id: String { pool }
    
    public init(pool: String, chain: String, project: String, symbol: String, tvlUsd: Double, apy: Double) {
        self.pool = pool
        self.chain = chain
        self.project = project
        self.symbol = symbol
        self.tvlUsd = tvlUsd
        self.apy = apy
    }
}
