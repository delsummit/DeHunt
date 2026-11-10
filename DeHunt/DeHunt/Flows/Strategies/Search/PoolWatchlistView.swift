//
//  PoolWatchlistView.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 25/02/2026.
//

import SwiftUI
import SwiftData

struct PoolWatchlistView: View {
    @Query(sort: \WatchlistPool.addedAt, order: .reverse) private var favoritePools: [WatchlistPool]
    @Bindable var viewModel: StrategiesViewModel

    var body: some View {
        Group {
            if favoritePools.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        refreshStatus

                        ForEach(favoritePools) { pool in
                            PoolCardWrapper(pool: pool.yieldPool, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.refreshWatchlist()
                }
            }
        }
        .background(.backgroundPrimary)
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.refreshWatchlist()
        }
    }

    @ViewBuilder
    private var refreshStatus: some View {
        if let errorMessage = viewModel.watchlistErrorMessage {
            Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundStyle(.textSecondary)
        } else if viewModel.isRefreshingWatchlist {
            ProgressView()
                .controlSize(.small)
        } else if let updatedAt = viewModel.watchlistUpdatedAt {
            Text("APY and TVL updated \(updatedAt, style: .relative) ago")
                .font(.caption)
                .foregroundStyle(.textSecondary)
        }
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
    let container = try! ModelContainer(for: WatchlistPool.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    container.mainContext.insert(WatchlistPool(pool: YieldPool(
        pool: "aave-v3-usdc-ethereum",
        chain: "Ethereum",
        project: "Aave V3",
        symbol: "USDC",
        tvlUsd: 1250000000,
        apy: 3.45
    )))

    container.mainContext.insert(WatchlistPool(pool: YieldPool(
        pool: "curve-3pool-ethereum",
        chain: "Ethereum",
        project: "Curve",
        symbol: "3CRV",
        tvlUsd: 850000000,
        apy: 5.67
    )))

    return NavigationStack {
        PoolWatchlistView(viewModel: StrategiesViewModel(modelContext: container.mainContext))
            .modelContainer(container)
    }
}

#Preview("Strategies") {
    StrategiesView()
}
