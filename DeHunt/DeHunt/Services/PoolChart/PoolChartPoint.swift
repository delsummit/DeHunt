//
//  PoolChartPoint.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 09/11/2026.
//

import Foundation

nonisolated struct PoolChartResponse: Decodable, Sendable {
    let data: [PoolChartPoint]
}

nonisolated struct PoolChartPoint: Decodable, Sendable, Equatable {
    let tvlUsd: Double?
    let apy: Double?
}
