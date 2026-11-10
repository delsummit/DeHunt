//
//  WatchlistRefresher.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 09/11/2026.
//

import Foundation

nonisolated struct PoolSnapshot: Sendable, Equatable {
    let apy: Double
    let tvlUsd: Double
}

nonisolated struct WatchlistRefresher: Sendable {

    private let apiClient: any DeFiAPIClientProtocol
    private let maxConcurrentRequests: Int

    init(apiClient: any DeFiAPIClientProtocol, maxConcurrentRequests: Int = 4) {
        self.apiClient = apiClient
        self.maxConcurrentRequests = max(1, maxConcurrentRequests)
    }

    func latestSnapshots(for poolIds: [String]) async -> [String: PoolSnapshot] {
        var seen = Set<String>()
        var pending = poolIds.filter { seen.insert($0).inserted }.makeIterator()

        return await withTaskGroup(of: (id: String, snapshot: PoolSnapshot?).self) { group in
            for _ in 0..<maxConcurrentRequests {
                guard let id = pending.next() else { break }
                group.addTask { await fetchSnapshot(for: id) }
            }

            var snapshots: [String: PoolSnapshot] = [:]
            for await result in group {
                if let snapshot = result.snapshot {
                    snapshots[result.id] = snapshot
                }
                if let id = pending.next() {
                    _ = group.addTaskUnlessCancelled { await fetchSnapshot(for: id) }
                }
            }
            return snapshots
        }
    }

    private func fetchSnapshot(for poolId: String) async -> (id: String, snapshot: PoolSnapshot?) {
        guard let history = try? await apiClient.fetchPoolChart(poolId: poolId),
              let latest = history.last,
              let apy = latest.apy,
              let tvlUsd = latest.tvlUsd else {
            return (poolId, nil)
        }
        return (poolId, PoolSnapshot(apy: apy, tvlUsd: tvlUsd))
    }
}
