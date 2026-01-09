//
//  StrategiesViewModel.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 04/01/2026.
//

import SwiftUI
import Observation

@Observable
final class StrategiesViewModel {
    // MARK: - Properties
    var selectedChains: Set<BlockchainChain> = []
    var investmentAmount: String = ""
    var minimumAPY: Double = 10.0
    var isChainSelectionPresented = false
    
    var selectedChainsArray: [BlockchainChain] {
        BlockchainChain.allCases
            .filter { selectedChains.contains($0) }
            .sorted { $0.rawValue < $1.rawValue }
    }
    
    var availableChains: [BlockchainChain] {
        BlockchainChain.allCases
            .filter { !selectedChains.contains($0) }
            .sorted { $0.rawValue < $1.rawValue }
    }
    
    var hasSelectedChains: Bool {
        !selectedChains.isEmpty
    }
    
    var selectedChainsCount: Int {
        selectedChains.count
    }
    
    var validInvestmentAmount: Double? {
        guard !investmentAmount.isEmpty else { return nil }
        return Double(investmentAmount.replacingOccurrences(of: ",", with: "."))
    }
    
    // MARK: - Actions

    func toggleChain(_ chain: BlockchainChain) {
        if selectedChains.contains(chain) {
            selectedChains.remove(chain)
        } else {
            selectedChains.insert(chain)
        }
    }
    
    func clearAllChains() {
        selectedChains.removeAll()
    }
    
    func toggleChainSelection() {
        isChainSelectionPresented.toggle()
    }
    
    func setInvestmentAmount(_ amount: String) {
        investmentAmount = amount
    }
    
    func isChainSelected(_ chain: BlockchainChain) -> Bool {
        selectedChains.contains(chain)
    }
    
    // MARK: - Filters
    func filterPools(_ pools: [YieldPool]) -> [YieldPool] {
        guard hasSelectedChains else {
            return pools
        }
        
        return pools.filter { pool in
            selectedChains.contains { chain in
                chain.apiChainNames.contains(pool.chain)
            }
        }
    }
    
    func filterPoolsByInvestment(_ pools: [YieldPool]) -> [YieldPool] {
        guard let amount = validInvestmentAmount else {
            return pools
        }
        
        return pools.filter { pool in
            pool.tvlUsd >= amount
        }
    }
    
    func filterPoolsByAPY(_ pools: [YieldPool]) -> [YieldPool] {
        guard minimumAPY > 0 else {
            return pools
        }
        
        return pools.filter { pool in
            pool.apy >= minimumAPY
        }
    }
    
    func applyAllFilters(_ pools: [YieldPool]) -> [YieldPool] {
        let chainFiltered = filterPools(pools)
        let investmentFiltered = filterPoolsByInvestment(chainFiltered)
        let apyFiltered = filterPoolsByAPY(investmentFiltered)
        return apyFiltered
    }
}
