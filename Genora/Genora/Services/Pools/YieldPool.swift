//
//  YieldPool.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import Foundation

struct YieldPoolResponse: Decodable {
    var response: String
    var data: [YieldPool]
}

struct YieldPool: Decodable, Identifiable, Hashable {
    var id: String { pool }
    let pool: String
    let chain: String
    let project: String
    let symbol: String
    let tvlUsd: Double
    let apy: Double
}
