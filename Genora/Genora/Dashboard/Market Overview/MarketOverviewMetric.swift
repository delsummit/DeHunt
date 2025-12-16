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
     case activeStrategies(count: Int, newCount: Int)
     case averageAPY(percent: Double, changePercent: Double)
     case topProtocol(name: String, tvl: Double, changePercent: Double)
     case topChain(name: String, tvl: Double, changePercent: Double)
    
    var id: String {
        switch self {
        case .tvl: return "tvl"
        case .activeStrategies: return "strategies"
        case .averageAPY: return "apy"
        case .topProtocol: return "topProtocol"
        case .topChain: return "topChain"
        }
    }
    
    var title: String {
        switch self {
        case .tvl: return "Total Market TVL"
        case .activeStrategies: return "Active strategies"
        case .averageAPY: return "Average APY"
        case .topProtocol: return "Top Protocol"
        case .topChain: return "Top Chain"
        }
    }
    
    var valueText: String {
        switch self {
        case .tvl(let value, _):
            return "$\(formatNumber(value))M"
        case .activeStrategies(let count, _):
            return "\(count)"
        case .averageAPY(let percent, _):
            return "\(formatNumber(percent))%"
        case .topProtocol(let name, _, _):
            return "\(name)"
        case .topChain(let name, _, _):
            return "\(name)"
        }
    }
    
    var subtitleText: String {
        switch self {
        case .tvl(_, let change):
            return formatChange(change, isPercent: true)
        case .activeStrategies(_, let new):
            return "+\(new) new"
        case .averageAPY(_, let change):
            return formatChange(change, isPercent: true)
        case .topProtocol(_, let tvl, let change):
            return "$\(formatNumber(tvl))M (\(formatChange(change, isPercent: true)))"
        case .topChain(_, let tvl, let change):
            return "$\(formatNumber(tvl))M (\(formatChange(change, isPercent: true)))"
        }
    }
    
    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func formatChange(_ value: Double, isPercent: Bool) -> String {
        let sign = value >= 0 ? "+" : ""
        let formatted = formatNumber(abs(value))
        return isPercent ? "\(sign)\(formatted)%" : "\(sign)\(formatted)"
    }
}
