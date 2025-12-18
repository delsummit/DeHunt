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
        case .tvl: return "Total Market TVL"
        case .averageAPY: return "Average APY"
        case .topProtocol: return "Top Protocol"
        case .topChain: return "Top Chain"
        }
    }
    
    var valueText: String {
        switch self {
        case .tvl(let value, _):
            return "\(formatNumber(value))"
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
        case .averageAPY(_, let change):
            return formatChange(change, isPercent: true)
        case .topProtocol(_, let tvl, let change):
            return "\(formatNumber(tvl)) (\(formatChange(change, isPercent: true)))"
        case .topChain(_, let tvl, let change):
            return "\(formatNumber(tvl)) (\(formatChange(change, isPercent: true)))"
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
    
    private func formatNumber(_ value: Double) -> String {
        let absValue = abs(value)
        let sign = value < 0 ? "-" : ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        
        switch absValue {
        case 1_000_000_000...:
            let billions = absValue / 1_000_000_000
            let formatted = formatter.string(from: NSNumber(value: billions)) ?? "\(billions)"
            return "\(sign)\(formatted)B"
        case 1_000_000...:
            let millions = absValue / 1_000_000
            let formatted = formatter.string(from: NSNumber(value: millions)) ?? "\(millions)"
            return "\(sign)\(formatted)M"
        case 1_000...:
            let thousands = absValue / 1_000
            let formatted = formatter.string(from: NSNumber(value: thousands)) ?? "\(thousands)"
            return "\(sign)\(formatted)K"
        default:
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }
    
    private func formatChange(_ value: Double, isPercent: Bool) -> String {
        let sign = value >= 0 ? "+" : ""
        let formatted = formatNumber(value)
        return isPercent ? "\(sign)\(formatted)%" : "\(sign)\(formatted)"
    }
}
