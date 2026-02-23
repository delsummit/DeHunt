//
//  PoolSortOption.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 11/01/2026.
//

import Foundation

enum SortDirection {
    case descending
    case ascending
    
    var icon: String {
        switch self {
        case .descending:
            return "arrow.down"
        case .ascending:
            return "arrow.up"
        }
    }
    
    mutating func toggle() {
        self = self == .descending ? .ascending : .descending
    }
}

enum PoolSortOption: CaseIterable, Identifiable {
    case none
    case tvl
    case apy
    
    var id: String {
        switch self {
        case .none: return "none"
        case .tvl: return "tvl"
        case .apy: return "apy"
        }
    }
    
    var icon: String {
        switch self {
        case .none:
            return "line.3.horizontal.decrease"
        case .tvl:
            return "bitcoinsign.bank.building"
        case .apy:
            return "chart.line.uptrend.xyaxis"
        }
    }
    
    var displayName: String {
        switch self {
        case .none:
            return "Default"
        case .tvl:
            return "TVL"
        case .apy:
            return "APY"
        }
    }
    
    func sort(_ pools: [YieldPool], direction: SortDirection) -> [YieldPool] {
        switch self {
        case .none:
            return pools.sorted { $0.tvlUsd > $1.tvlUsd }
        case .tvl:
            return direction == .descending
                ? pools.sorted { $0.tvlUsd > $1.tvlUsd }
                : pools.sorted { $0.tvlUsd < $1.tvlUsd }
        case .apy:
            return direction == .descending
                ? pools.sorted { $0.apy > $1.apy }
                : pools.sorted { $0.apy < $1.apy }
        }
    }
}
