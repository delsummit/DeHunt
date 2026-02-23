//
//  StrategiesSearchResultView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 11/01/2026.
//

import SwiftUI

struct StrategiesSearchResultView: View {
    let pools: [YieldPool]
    @Bindable var viewModel: StrategiesViewModel
    
    @State private var sortOption: PoolSortOption = .none
    @State private var sortDirection: SortDirection = .descending
    
    private var displayedPools: [YieldPool] {
        pools.isEmpty ? viewModel.filteredPools : pools
    }
    
    private var sortedPools: [YieldPool] {
        sortOption.sort(displayedPools, direction: sortDirection)
    }
    
    var body: some View {
        Group {
            if displayedPools.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(sortedPools) { pool in
                            
                            StrategiesSearchResultPoolRow(pool: pool)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Results (\(viewModel.filteredPools.count))")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by project, symbol, or chain"
            )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker(selection: Binding(
                        get: { sortOption },
                        set: { newValue in
                            if sortOption == newValue && newValue != .none {
                                sortDirection.toggle()
                            } else {
                                sortOption = newValue
                                sortDirection = .descending
                            }
                        }
                    )) {
                        ForEach(PoolSortOption.allCases) { option in
                            HStack {
                                Image(systemName: option.icon)
                                Text(option.displayName)
                                
                                if sortOption == option && option != .none {
                                    Spacer()
                                    Image(systemName: sortDirection.icon)
                                        .font(.caption)
                                }
                            }
                            .tag(option)
                        }
                    } label: {
                        EmptyView()
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: sortOption.icon)
                        if sortOption != .none {
                            Image(systemName: sortDirection.icon)
                                .fontWeight(.regular)
                        }
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbar(.hidden, for: .tabBar)
        .background(.backgroundPrimary)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.textSecondary.opacity(0.5))
            
            Text("No pools found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)
            
            Text("Try adjusting your filters to see more results")
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        StrategiesSearchResultView(pools: [
            YieldPool(
                pool: "1",
                chain: "Ethereum",
                project: "Aave",
                symbol: "USDC",
                tvlUsd: 1250000,
                apy: 5.67
            ),
            YieldPool(
                pool: "2",
                chain: "Polygon",
                project: "Uniswap",
                symbol: "ETH-USDT",
                tvlUsd: 3400000,
                apy: 12.34
            ),
            YieldPool(
                pool: "3",
                chain: "Arbitrum",
                project: "Curve",
                symbol: "DAI-USDC-USDT",
                tvlUsd: 8900000,
                apy: 8.92
            )
        ],
        viewModel: StrategiesViewModel()
        )
    }
}


#Preview("Strategies") {
    MainView()
}
