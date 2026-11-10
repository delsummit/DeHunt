//
//  WatchlistRefresherTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

final class WatchlistRefresherTests: XCTestCase {

    func testReturnsTheLatestPointOfEachPool() async {
        var client = MockDeFiAPIClient()
        client.poolCharts = [
            "a": .success([PoolChartPoint(tvlUsd: 100, apy: 1), PoolChartPoint(tvlUsd: 200, apy: 2)]),
            "b": .success([PoolChartPoint(tvlUsd: 300, apy: 3)])
        ]

        let snapshots = await WatchlistRefresher(apiClient: client).latestSnapshots(for: ["a", "b"])

        XCTAssertEqual(snapshots, [
            "a": PoolSnapshot(apy: 2, tvlUsd: 200),
            "b": PoolSnapshot(apy: 3, tvlUsd: 300)
        ])
    }

    func testLeavesOutFailedEmptyAndIncompletePools() async {
        var client = MockDeFiAPIClient()
        client.poolCharts = [
            "ok": .success([PoolChartPoint(tvlUsd: 10, apy: 5)]),
            "failed": .failure(TestError()),
            "empty": .success([]),
            "noAPY": .success([PoolChartPoint(tvlUsd: 10, apy: nil)])
        ]

        let snapshots = await WatchlistRefresher(apiClient: client)
            .latestSnapshots(for: ["ok", "failed", "empty", "noAPY", "unknown"])

        XCTAssertEqual(snapshots, ["ok": PoolSnapshot(apy: 5, tvlUsd: 10)])
    }

    func testFetchesDuplicateIDsOnce() async {
        let client = MockDeFiAPIClient()

        _ = await WatchlistRefresher(apiClient: client).latestSnapshots(for: ["a", "b", "a", "a"])

        XCTAssertEqual(client.chartRequests.requested.sorted(), ["a", "b"])
    }

    func testEmptyWatchlistSendsNoRequests() async {
        let client = MockDeFiAPIClient()

        let snapshots = await WatchlistRefresher(apiClient: client).latestSnapshots(for: [])

        XCTAssertTrue(snapshots.isEmpty)
        XCTAssertTrue(client.chartRequests.requested.isEmpty)
    }

    func testRunsRequestsInParallelUpToTheLimit() async {
        var client = MockDeFiAPIClient()
        client.chartDelay = .milliseconds(50)
        let ids = (1...10).map { "pool-\($0)" }
        client.poolCharts = Dictionary(uniqueKeysWithValues: ids.map { ($0, .success([PoolChartPoint(tvlUsd: 1, apy: 1)])) })

        let snapshots = await WatchlistRefresher(apiClient: client, maxConcurrentRequests: 3).latestSnapshots(for: ids)

        XCTAssertEqual(snapshots.count, 10, "Every pool is still fetched")
        XCTAssertLessThanOrEqual(client.chartRequests.peakInFlight, 3, "Never more than the limit at once")
        XCTAssertGreaterThan(client.chartRequests.peakInFlight, 1, "Requests overlap instead of running one by one")
    }

    func testCancellationStopsStartingNewRequests() async {
        var client = MockDeFiAPIClient()
        client.chartDelay = .milliseconds(200)
        let ids = (1...20).map { "pool-\($0)" }
        let refresher = WatchlistRefresher(apiClient: client, maxConcurrentRequests: 2)

        let task = Task { await refresher.latestSnapshots(for: ids) }
        try? await Task.sleep(for: .milliseconds(50))
        task.cancel()
        _ = await task.value

        XCTAssertEqual(client.chartRequests.requested.count, 2, "Only the first window started")
    }
}
