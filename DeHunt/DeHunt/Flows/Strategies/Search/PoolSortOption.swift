//
//  PoolSortOption.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 11/01/2026.
//

import Foundation

enum PoolSortOption: String, CaseIterable, Identifiable {
    case none = "Default"
    case tvlHighToLow = "TVL: Descending"
    case tvlLowToHigh = "TVL: Ascending"
    case apyHighToLow = "APY: Descending"
    case apyLowToHigh = "APY: Ascending"
    
    var id: String { rawValue }
    
    var firstIcon: String {
        switch self {
        case .none:
            return "line.3.horizontal.decrease"
        case .apyHighToLow, .apyLowToHigh:
            return "percent"
        case .tvlHighToLow, .tvlLowToHigh:
            return "lock.badge.clock.fill"
        }
    }
    var secondIcon: String {
        switch self {
        case .none:
            return "line.3.horizontal.decrease"
        case .tvlHighToLow, .apyHighToLow:
            return "arrow.down"
        case .tvlLowToHigh, .apyLowToHigh:
            return "arrow.up"
        }
    }
    
    func sort(_ pools: [YieldPool]) -> [YieldPool] {
        switch self {
        case .none:
            return pools.sorted { $0.tvlUsd > $1.tvlUsd }
        case .tvlHighToLow:
            return pools.sorted { $0.tvlUsd > $1.tvlUsd }
        case .tvlLowToHigh:
            return pools.sorted { $0.tvlUsd < $1.tvlUsd }
        case .apyHighToLow:
            return pools.sorted { $0.apy > $1.apy }
        case .apyLowToHigh:
            return pools.sorted { $0.apy < $1.apy }
        }
    }
}
