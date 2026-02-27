//
//  PoolWatchlistView.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 25/02/2026.
//

import SwiftUI
import SwiftData

struct PoolWatchlistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoritePools: [YieldPool]
    @Bindable var viewModel: StrategiesViewModel
    
    var body: some View {
        Group {
            if favoritePools.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(favoritePools) { pool in
                            PoolCardWrapper(pool: pool, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(.backgroundPrimary)
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundStyle(.element.opacity(0.5))
            
            Text("Nothing here yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)
            
            Text("Long press on any pool see magic happen!")
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let container = try! ModelContainer(for: YieldPool.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let pool1 = YieldPool(
        pool: "aave-v3-usdc-ethereum",
        chain: "Ethereum",
        project: "Aave V3",
        symbol: "USDC",
        tvlUsd: 1250000000,
        apy: 3.45
    )
    
    let pool2 = YieldPool(
        pool: "curve-3pool-ethereum",
        chain: "Ethereum",
        project: "Curve",
        symbol: "3CRV",
        tvlUsd: 850000000,
        apy: 5.67
    )
    
    container.mainContext.insert(pool1)
    container.mainContext.insert(pool2)
    
    return NavigationStack {
        PoolWatchlistView(viewModel: StrategiesViewModel())
            .modelContainer(container)
    }
}

#Preview("Strategies") {
    StrategiesView()
}
