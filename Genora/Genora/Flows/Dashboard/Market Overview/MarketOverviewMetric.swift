//
//  MarketOverviewMetric.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 16/12/2025.
//

import SwiftUI

// MARK: - Market Overview Metric Types
enum MarketOverviewMetric: Identifiable {
     case tvl(value: Double, changePercent: Double)
     case averageAPY(percent: Double, changePercent: Double)
     case topProtocol(name: String, tvl: Double, changePercent: Double)
     case topChain(name: String, tvl: Double, changePercent: Double)
    
    var id: String {
        switch self {
        case .tvl: return "tvl"
        case .averageAPY: return "apy"
        case .topProtocol: return "topProtocol"
        case .topChain: return "topChain"
        }
    }
    
    var title: String {
        switch self {
        case .tvl: return "Market TVL*"
        case .averageAPY: return "Average APY"
        case .topProtocol: return "Top Protocol"
        case .topChain: return "Top Chain"
        }
    }
    
    var valueText: String {
        switch self {
        case .tvl(let value, _):
            return value.formatted(currency: true)
        case .averageAPY(let percent, _):
            return "\(percent.formatted())%"
        case .topProtocol(let name, _, _):
            return name
        case .topChain(let name, _, _):
            return name
        }
    }
    
    var subtitleText: String {
        switch self {
        case .tvl(_, let change):
            return change.formattedChange()
        case .averageAPY(_, let change):
            return change.formattedChange()
        case .topProtocol(_, let tvl, let change):
            return "\(tvl.formatted(currency: true)) (\(change.formattedChange()))"
        case .topChain(_, let tvl, let change):
            return "\(tvl.formatted(currency: true)) (\(change.formattedChange()))"
        }
    }
    
    var changePercent: Double {
        switch self {
        case .tvl(_, let change),
             .averageAPY(_, let change),
             .topProtocol(_, _, let change),
             .topChain(_, _, let change):
            return change
        }
    }
    
    var changeColor: Color {
        return changePercent >= 0 ? .textPositive : .textNegative
    }
}
