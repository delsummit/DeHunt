//
//  DashboardViewModel.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 18/12/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class DashboardViewModel {
    var metrics: [MarketOverviewMetric] = []
    var errorMessage: String?
    
    private let categoryBlacklist: Set<String> = ["CEX", "Liquid Staking"]
    private let minimumTVL: Double = 10_000_000
    
    init() {}
    
    // MARK: - Public Methods
    
    func loadMetrics() async {
        errorMessage = nil
        
        do {
            let protocols = try await ChainsService.shared.fetchChains()
            metrics = calculateMetrics(from: protocols)
        } catch LiamaAPIError.invalidURL {
            errorMessage = "Invalid URL"
        } catch LiamaAPIError.invalidResponse {
            errorMessage = "Invalid response"
        } catch LiamaAPIError.invalidData {
            errorMessage = "Invalid data"
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
    }
    
    // MARK: - Private Methods
    
    private func calculateMetrics(from allProtocols: [ProtocolsTVL]) -> [MarketOverviewMetric] {
        let protocols = filterProtocols(allProtocols)
        
        guard !protocols.isEmpty else { return [] }
        
        let totalTVL = calculateTotalTVL(protocols)
        let weightedChange = calculateWeightedChange(protocols, totalTVL: totalTVL)
        
        guard let topProtocol = findTopProtocol(protocols) else { return [] }
        
        let topProtocolTVL = topProtocol.tvl ?? 0
        let topProtocolChange = topProtocol.change_1d ?? 0
        
        // TODO: MOCK APY, REPLACE
        let avgAPY = 18.5
        let apyChange = 2.1
        
        guard let (topChainName, topChainTVL, topChainChange) = findTopChain(protocols) else {
            return []
        }
        
        return [
            .tvl(value: totalTVL, changePercent: weightedChange),
            .averageAPY(percent: avgAPY, changePercent: apyChange),
            .topProtocol(name: topProtocol.name, tvl: topProtocolTVL, changePercent: topProtocolChange),
            .topChain(name: topChainName, tvl: topChainTVL, changePercent: topChainChange)
        ]
    }
    
    // MARK: - Private Methods
    
    private func filterProtocols(_ protocols: [ProtocolsTVL]) -> [ProtocolsTVL] {
        protocols.filter { proto in
            guard let tvl = proto.tvl, tvl >= minimumTVL else { return false }
            
            guard let category = proto.category else { return true }
            return !categoryBlacklist.contains(category)
        }
    }
    
    private func calculateTotalTVL(_ protocols: [ProtocolsTVL]) -> Double {
        protocols.reduce(0.0) { $0 + ($1.tvl ?? 0) }
    }
    
    private func calculateWeightedChange(_ protocols: [ProtocolsTVL], totalTVL: Double) -> Double {
        let weightedSum = protocols.reduce(0.0) { sum, proto in
            let tvl = proto.tvl ?? 0
            let change = proto.change_1d ?? 0
            return sum + (tvl * change)
        }
        
        let weightedChange = weightedSum / totalTVL
        return weightedChange
    }
    
    private func findTopProtocol(_ protocols: [ProtocolsTVL]) -> ProtocolsTVL? {
        protocols.max(by: { ($0.tvl ?? 0) < ($1.tvl ?? 0) })
    }
    
    private func findTopChain(_ protocols: [ProtocolsTVL]) -> (name: String, tvl: Double, change: Double)? {
        var chainTVLs: [String: Double] = [:]
        for proto in protocols {
            if let chains = proto.chains, let tvl = proto.tvl {
                for chain in chains {
                    chainTVLs[chain, default: 0] += tvl
                }
            }
        }
        
        guard let topChainPair = chainTVLs.max(by: { $0.value < $1.value }) else {
            return nil
        }
        let topChainTVL = topChainPair.value
        let topChainProtocols = protocols.filter {
            $0.chains?.contains(topChainPair.key) ?? false
        }
        let topChainChange = calculateWeightedChangeForChain(topChainProtocols)
                
        return (topChainPair.key, topChainTVL, topChainChange)
    }
    
    private func calculateWeightedChangeForChain(_ protocols: [ProtocolsTVL]) -> Double {
        let totalTVL = protocols.reduce(0.0) { $0 + ($1.tvl ?? 0) }
        
        guard totalTVL > 0 else { return 0 }
        
        let weightedSum = protocols.reduce(0.0) { sum, proto in
            let tvl = proto.tvl ?? 0
            let change = proto.change_1d ?? 0
            return sum + (tvl * change)
        }
        
        return weightedSum / totalTVL
    }
}
