//
//  MetricsCalculator.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

struct MetricsCalculator {
    private let minTVL: Double
    private let excludedCategories: Set<String>
    
    init(minTVL: Double = 10_000_000, excludedCategories: Set<String> = ["CEX", "CeDeFi", "Liquid Staking", "Staking Pool", "Liquid Restaking", "Restaking", "Restaked BTC", "Staking Rental", "Chain", "Services", "Launchpad", "Gaming", "NFT Marketplace", "NFT Lending", "NFT Launchpad", "NftFi", "NFT Automated Strategies", "Meme", "Portfolio tracker", "Oracle", "Portfolio Tracker", "Wallets", "Telegram Bot", "Interface"]) {
        self.minTVL = minTVL
        self.excludedCategories = excludedCategories
    }
    
    // MARK: - Public API
        func calculate(from protocols: [ProtocolsTVL]) -> [MarketOverviewMetric] {
        let filtered = filter(protocols)
        
        guard !filtered.isEmpty else { return [] }
        
        let totalTVL = calculateTotalTVL(filtered)
        let tvlChange = calculateWeightedChange(filtered, totalTVL: totalTVL)
        
        guard let topProtocol = findTopProtocol(filtered),
              let topChain = findTopChain(filtered) else {
            return []
        }
        
        // TODO: Replace with real APY
        let avgAPY = 18.5
        let apyChange = 2.1
        
        return [
            .tvl(value: totalTVL, changePercent: tvlChange),
            .averageAPY(percent: avgAPY, changePercent: apyChange),
            .topProtocol(name: topProtocol.name, tvl: topProtocol.tvl ?? 0, changePercent: topProtocol.change_1d ?? 0),
            .topChain(name: topChain.name, tvl: topChain.tvl, changePercent: topChain.change)
        ]
    }
    
    // MARK: - Private Helpers
    private func filter(_ protocols: [ProtocolsTVL]) -> [ProtocolsTVL] {
        protocols.filter { proto in
            guard let tvl = proto.tvl, tvl >= minTVL else { return false }
            guard let category = proto.category else { return true }
            return !excludedCategories.contains(category)
        }
    }
    
    private func calculateTotalTVL(_ protocols: [ProtocolsTVL]) -> Double {
        protocols.reduce(0.0) { $0 + ($1.tvl ?? 0) }
    }
    
    private func calculateWeightedChange(_ protocols: [ProtocolsTVL], totalTVL: Double) -> Double {
        guard totalTVL > 0 else { return 0 }
        
        let weightedSum = protocols.reduce(0.0) { sum, proto in
            let tvl = proto.tvl ?? 0
            let change = proto.change_1d ?? 0
            return sum + (tvl * change)
        }
        
        return weightedSum / totalTVL
    }
    
    private func findTopProtocol(_ protocols: [ProtocolsTVL]) -> ProtocolsTVL? {
        protocols.max(by: { ($0.tvl ?? 0) < ($1.tvl ?? 0) })
    }
    
    private func findTopChain(_ protocols: [ProtocolsTVL]) -> (name: String, tvl: Double, change: Double)? {
        var chainData: [String: (tvl: Double, protocols: [ProtocolsTVL])] = [:]
        
        for proto in protocols {
            guard let chains = proto.chains, let tvl = proto.tvl else { continue }
            
            for chain in chains {
                if chainData[chain] != nil {
                    chainData[chain]!.tvl += tvl
                    chainData[chain]!.protocols.append(proto)
                } else {
                    chainData[chain] = (tvl, [proto])
                }
            }
        }
        
        guard let topChain = chainData.max(by: { $0.value.tvl < $1.value.tvl }) else {
            return nil
        }
        
        let totalTVL = topChain.value.tvl
        let change = calculateWeightedChange(topChain.value.protocols, totalTVL: totalTVL)
        
        return (topChain.key, totalTVL, change)
    }
}
