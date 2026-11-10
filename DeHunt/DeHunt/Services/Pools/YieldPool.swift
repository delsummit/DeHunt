//
//  YieldPool.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import Foundation

nonisolated struct YieldPoolResponse: Decodable, Sendable {
    let status: String
    let data: [YieldPool]
}

nonisolated struct YieldPool: Identifiable, Hashable, Decodable, Sendable {
    let pool: String
    let chain: String
    let project: String
    let symbol: String
    let tvlUsd: Double
    let apy: Double

    var id: String { pool }
}
