//
//  StrategiesViewModel.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 04/01/2026.
//

import Foundation
import Observation
import Combine

@Observable
final class StrategiesViewModel {
    // MARK: - Properties
    var selectedChains: Set<BlockchainChain> = []
    var investmentAmount: Double? = nil
    var minTVLValue: Double? = nil
    var minimumAPY: Double = 10.0
    var isChainSelectionPresented = false
    
    var pools: [YieldPool] = []
    var filteredPools: [YieldPool] = []
    var isLoading = false
    var errorMessage: String?
    var shouldShowResults = false
    
    var searchText: String = "" {
        didSet {
            searchTextSubject.send(searchText)
        }
    }
    
    private let apiClient: DeFiAPIClientProtocol
    
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(apiClient: DeFiAPIClientProtocol = DeFiAPIClient()) {
        self.apiClient = apiClient
        setupSearchDebounce()
    }
    
    func cleanup() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
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
        investmentAmount
    }
    
    var validTVLValue: Double? {
        minTVLValue
    }

    
    // MARK: - Actions
    
    private func setupSearchDebounce() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchQuery in
                guard let self = self else { return }
                guard !self.pools.isEmpty else { return }
                self.filteredPools = self.applyAllFilters(self.pools)
            }
            .store(in: &cancellables)
    }

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
    
    func setInvestmentAmount(_ amount: Double?) {
        investmentAmount = amount
    }
    
    func setMinTVLAmount(_ value: Double?) {
        minTVLValue = value
    }
    
    func isChainSelected(_ chain: BlockchainChain) -> Bool {
        selectedChains.contains(chain)
    }
    
    // MARK: - Filters
    func filterPools(_ pools: [YieldPool]) -> [YieldPool] {
        let supportedChains = Set(
            BlockchainChain.allCases.flatMap { $0.apiChainNames }
        )
        
        guard hasSelectedChains else {
            return pools.filter { pool in
                supportedChains.contains(pool.chain)
            }
        }
        
        return pools.filter { pool in
            selectedChains.contains { chain in
                chain.apiChainNames.contains(pool.chain)
            }
        }
    }
    
    func filterPoolsByTVL(_ pools: [YieldPool]) -> [YieldPool] {
        guard let value = validTVLValue else {
            return pools
        }
        
        return pools.filter { pool in
            pool.tvlUsd >= value
        }
    }
    
    func filterPoolsByAPY(_ pools: [YieldPool]) -> [YieldPool] {
        return pools.filter { pool in
            pool.apy >= minimumAPY
        }
    }
    
    func filterPoolsBySearchText(_ pools: [YieldPool]) -> [YieldPool] {
        guard !searchText.isEmpty else {
            return pools
        }
        
        let lowercaseQuery = searchText.lowercased()
        
        return pools.filter { pool in
            pool.project.lowercased().contains(lowercaseQuery) ||
            pool.symbol.lowercased().contains(lowercaseQuery) ||
            pool.chain.lowercased().contains(lowercaseQuery)
        }
    }
    
    func applyAllFilters(_ pools: [YieldPool]) -> [YieldPool] {
        let chainFiltered = filterPools(pools)
        let tvlFiltered = filterPoolsByTVL(chainFiltered)
        let apyFiltered = filterPoolsByAPY(tvlFiltered)
        let searchFiltered = filterPoolsBySearchText(apyFiltered)
        return searchFiltered
    }
    
    func performSearch() async {
        isLoading = true
        errorMessage = nil
        shouldShowResults = false
        searchText = ""
        
        do {
            pools = try await apiClient.fetchYieldPools()
            filteredPools = applyAllFilters(pools)
            
            shouldShowResults = true
        } catch {
            errorMessage = "\(error.localizedDescription)"
            pools = []
            filteredPools = []
            shouldShowResults = false
        }
        
        isLoading = false
    }
}
