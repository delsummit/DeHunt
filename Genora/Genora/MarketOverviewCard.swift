//
//  MarketOverviewCard.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 16/12/2025.
//

import SwiftUI

// MARK: - Dashboard Metric Types
enum DashboardMetric: Identifiable {
    case tvl(value: Double, changePercent: Double)
    case activeStrategies(count: Int, newCount: Int)
    case volume(value: Double, changePercent: Double)
    case activeUsers(count: Int, todayCount: Int)
    case averageAPY(percent: Double, changePercent: Double)
    case totalRewards(value: Double, recentChange: Double)
    
    var id: String {
        switch self {
        case .tvl: return "tvl"
        case .activeStrategies: return "strategies"
        case .volume: return "volume"
        case .activeUsers: return "users"
        case .averageAPY: return "apy"
        case .totalRewards: return "rewards"
        }
    }
    
    var title: String {
        switch self {
        case .tvl: return "Total Market TVL"
        case .activeStrategies: return "Active strategies"
        case .volume: return "Total Volume"
        case .activeUsers: return "Active Users"
        case .averageAPY: return "Avg. APY"
        case .totalRewards: return "Total Rewards"
        }
    }
    
    var valueText: String {
        switch self {
        case .tvl(let value, _):
            return "$\(formatNumber(value))M"
        case .activeStrategies(let count, _):
            return "\(count)"
        case .volume(let value, _):
            return "$\(formatNumber(value))M"
        case .activeUsers(let count, _):
            return "\(formatNumber(Double(count)))"
        case .averageAPY(let percent, _):
            return "\(formatNumber(percent))%"
        case .totalRewards(let value, _):
            return "$\(formatNumber(value))M"
        }
    }
    
    var subtitleText: String {
        switch self {
        case .tvl(_, let change):
            return formatChange(change, isPercent: true)
        case .activeStrategies(_, let new):
            return "+\(new) new"
        case .volume(_, let change):
            return formatChange(change, isPercent: true)
        case .activeUsers(_, let today):
            return "+\(today) today"
        case .averageAPY(_, let change):
            return formatChange(change, isPercent: true)
        case .totalRewards(_, let change):
            return "+$\(formatNumber(change))K"
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

struct DashboardCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.textPositive)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.textPositive)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.backgroundSecondary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.border, lineWidth: 1)
        )
    }
}

#Preview {
    DashboardCard(title: "One", value: "1", subtitle: "2")
}
