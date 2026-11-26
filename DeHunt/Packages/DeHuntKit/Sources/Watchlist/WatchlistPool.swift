//
//  WatchlistPool.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 09/11/2026.
//

import Foundation
import SwiftData
import DefiLlama

@Model
public final class WatchlistPool {
    @Attribute(.unique) public var poolId: String
    var chain: String
    var project: String
    var symbol: String
    public var tvlUsd: Double
    public var apy: Double
    public var addedAt: Date
    public var updatedAt: Date

    public init(pool: YieldPool, now: Date = .now) {
        self.poolId = pool.pool
        self.chain = pool.chain
        self.project = pool.project
        self.symbol = pool.symbol
        self.tvlUsd = pool.tvlUsd
        self.apy = pool.apy
        self.addedAt = now
        self.updatedAt = now
    }

    public var yieldPool: YieldPool {
        YieldPool(pool: poolId, chain: chain, project: project, symbol: symbol, tvlUsd: tvlUsd, apy: apy)
    }

    public func apply(_ snapshot: PoolSnapshot, at date: Date = .now) {
        apy = snapshot.apy
        tvlUsd = snapshot.tvlUsd
        updatedAt = date
    }
}
