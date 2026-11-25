//
//  PoolChartPoint.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 09/11/2026.
//

import Foundation

public struct PoolChartResponse: Decodable, Sendable {
    public let data: [PoolChartPoint]
}

public struct PoolChartPoint: Decodable, Sendable, Equatable {
    public let tvlUsd: Double?
    public let apy: Double?
}
