//
//  StrategiesViewModelTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 18/01/2026.
//

import XCTest
import SwiftData
@testable import DeHunt

@MainActor
final class StrategiesViewModelTests: XCTestCase {

    private func makeSUT(
        apiClient: MockDeFiAPIClient = MockDeFiAPIClient(),
        container: ModelContainer? = nil
    ) -> StrategiesViewModel {
        StrategiesViewModel(apiClient: apiClient, modelContext: container.map(ModelContext.init))
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(for: WatchlistPool.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }

    private func savedPools(in container: ModelContainer) throws -> [WatchlistPool] {
        try ModelContext(container).fetch(FetchDescriptor<WatchlistPool>(sortBy: [SortDescriptor(\.poolId)]))
    }

    func testFilterPoolsByAPY() async {
        // ARRANGE
        let viewModel = makeSUT()
        viewModel.minimumAPY = 15.0

        let testPools = [
            YieldPool(pool: "pool-1", chain: "Ethereum", project: "Uniswap", symbol: "ETH-USDC", tvlUsd: 1_000_000, apy: 25.0),
            YieldPool(pool: "pool-2", chain: "Polygon", project: "QuickSwap", symbol: "MATIC-USDC", tvlUsd: 500_000, apy: 10.0),
            YieldPool(pool: "pool-3", chain: "Arbitrum", project: "Camelot", symbol: "ARB-ETH", tvlUsd: 750_000, apy: 15.0)
        ]

        // ACT
        let filteredPools = viewModel.filterPoolsByAPY(testPools)

        // ASSERT
        XCTAssertEqual(filteredPools.map(\.pool), ["pool-1", "pool-3"], "15% itself passes, 10% doesn't")
    }

    func testNoSelectedChainsKeepsOnlySupportedChains() async {
        let viewModel = makeSUT()
        let pools: [YieldPool] = [.fixture(id: "eth", chain: "Ethereum"), .fixture(id: "cardano", chain: "Cardano")]

        XCTAssertEqual(viewModel.filterPools(pools).map(\.pool), ["eth"])
    }

    func testSelectedChainsKeepOnlyTheirPools() async {
        let viewModel = makeSUT()
        viewModel.selectedChains = [.solana, .base]
        let pools: [YieldPool] = [
            .fixture(id: "sol", chain: "Solana"),
            .fixture(id: "base", chain: "Base"),
            .fixture(id: "eth", chain: "Ethereum")
        ]

        XCTAssertEqual(viewModel.filterPools(pools).map(\.pool), ["sol", "base"])
    }

    func testSelectedChainsMatchDefiLlamaChainNames() async {
        let viewModel = makeSUT()
        viewModel.selectedChains = [.optimism, .hyperliquid, .binance]
        let pools: [YieldPool] = [
            .fixture(id: "op", chain: "OP Mainnet"),
            .fixture(id: "hl", chain: "Hyperliquid L1"),
            .fixture(id: "bsc", chain: "BSC")
        ]

        XCTAssertEqual(viewModel.filterPools(pools).map(\.pool), ["op", "hl", "bsc"])
    }

    func testTVLFilterKeepsPoolsAtOrAboveTheMinimum() async {
        let viewModel = makeSUT()
        let pools: [YieldPool] = [.fixture(id: "small", tvlUsd: 99), .fixture(id: "exact", tvlUsd: 100), .fixture(id: "big", tvlUsd: 101)]

        XCTAssertEqual(viewModel.filterPoolsByTVL(pools).count, 3, "No minimum keeps everything")

        viewModel.setMinTVLAmount(100)
        XCTAssertEqual(viewModel.filterPoolsByTVL(pools).map(\.pool), ["exact", "big"])
    }

    func testSearchMatchesProjectSymbolOrChainIgnoringCase() async {
        let viewModel = makeSUT()
        let pools: [YieldPool] = [
            .fixture(id: "by-project", chain: "Ethereum", project: "lido", symbol: "STETH"),
            .fixture(id: "by-symbol", chain: "Base", project: "aerodrome", symbol: "LIDO-ETH"),
            .fixture(id: "by-chain", chain: "Solana", project: "kamino", symbol: "SOL"),
            .fixture(id: "no-match", chain: "Arbitrum", project: "gmx", symbol: "GLP")
        ]

        viewModel.searchText = "LiDo"
        XCTAssertEqual(viewModel.filterPoolsBySearchText(pools).map(\.pool), ["by-project", "by-symbol"])

        viewModel.searchText = "sola"
        XCTAssertEqual(viewModel.filterPoolsBySearchText(pools).map(\.pool), ["by-chain"])

        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filterPoolsBySearchText(pools).count, 4)
    }

    func testApplyAllFiltersCombinesEveryFilter() async {
        let viewModel = makeSUT()
        viewModel.selectedChains = [.ethereum]
        viewModel.setMinTVLAmount(1_000)
        viewModel.minimumAPY = 5
        viewModel.searchText = "aave"
        let pools: [YieldPool] = [
            .fixture(id: "match", chain: "Ethereum", project: "aave-v3", tvlUsd: 5_000, apy: 6),
            .fixture(id: "wrong-chain", chain: "Base", project: "aave-v3", tvlUsd: 5_000, apy: 6),
            .fixture(id: "low-tvl", chain: "Ethereum", project: "aave-v3", tvlUsd: 10, apy: 6),
            .fixture(id: "low-apy", chain: "Ethereum", project: "aave-v3", tvlUsd: 5_000, apy: 1),
            .fixture(id: "other-project", chain: "Ethereum", project: "lido", tvlUsd: 5_000, apy: 6)
        ]

        XCTAssertEqual(viewModel.applyAllFilters(pools).map(\.pool), ["match"])
    }

    func testPerformSearchLoadsAndFiltersPools() async {
        var client = MockDeFiAPIClient()
        client.yieldPools = .success([.fixture(id: "high", apy: 20), .fixture(id: "low", apy: 2)])
        let viewModel = makeSUT(apiClient: client)
        viewModel.minimumAPY = 10

        await viewModel.performSearch()

        XCTAssertEqual(viewModel.pools.count, 2)
        XCTAssertEqual(viewModel.filteredPools.map(\.pool), ["high"])
        XCTAssertTrue(viewModel.shouldShowResults)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testPerformSearchFailureShowsErrorAndClearsResults() async {
        var client = MockDeFiAPIClient()
        client.yieldPools = .failure(LlamaAPIError.invalidResponse)
        let viewModel = makeSUT(apiClient: client)

        await viewModel.performSearch()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.pools.isEmpty)
        XCTAssertTrue(viewModel.filteredPools.isEmpty)
        XCTAssertFalse(viewModel.shouldShowResults)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testTogglingAPoolSavesItThenRemovesIt() async throws {
        let container = try makeContainer()
        let viewModel = makeSUT(container: container)
        let pool = YieldPool.fixture(id: "p1", tvlUsd: 500, apy: 7)

        viewModel.togglePoolSelection(pool)

        XCTAssertTrue(viewModel.isPoolSelected("p1"))
        let saved = try savedPools(in: container)
        XCTAssertEqual(saved.map(\.poolId), ["p1"])
        XCTAssertEqual(saved.first?.yieldPool, pool)

        viewModel.togglePoolSelection(pool)

        XCTAssertFalse(viewModel.isPoolSelected("p1"))
        XCTAssertTrue(try savedPools(in: container).isEmpty)
    }

    func testLoadsSavedPoolIDsOnInit() async throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        context.insert(WatchlistPool(pool: .fixture(id: "saved")))
        try context.save()

        let viewModel = makeSUT(container: container)

        XCTAssertEqual(viewModel.selectedPoolIds, ["saved"])
    }

    func testRefreshWatchlistStoresFreshValuesAndKeepsOldOnesOnFailure() async throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        context.insert(WatchlistPool(pool: .fixture(id: "fresh", tvlUsd: 100, apy: 1)))
        context.insert(WatchlistPool(pool: .fixture(id: "failing", tvlUsd: 100, apy: 1)))
        try context.save()

        var client = MockDeFiAPIClient()
        client.poolCharts = [
            "fresh": .success([PoolChartPoint(tvlUsd: 900, apy: 9)]),
            "failing": .failure(TestError())
        ]
        let viewModel = makeSUT(apiClient: client, container: container)

        await viewModel.refreshWatchlist()

        let saved = try savedPools(in: container)
        XCTAssertEqual(saved.map(\.poolId), ["failing", "fresh"])
        XCTAssertEqual(saved[0].apy, 1, "A failed pool keeps its last known APY")
        XCTAssertEqual(saved[0].tvlUsd, 100)
        XCTAssertEqual(saved[1].apy, 9)
        XCTAssertEqual(saved[1].tvlUsd, 900)
        XCTAssertNotNil(viewModel.watchlistUpdatedAt)
        XCTAssertNil(viewModel.watchlistErrorMessage)
        XCTAssertFalse(viewModel.isRefreshingWatchlist)
    }

    func testRefreshWatchlistShowsErrorWhenEveryRequestFails() async throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        context.insert(WatchlistPool(pool: .fixture(id: "p1", apy: 4)))
        try context.save()

        var client = MockDeFiAPIClient()
        client.poolCharts = ["p1": .failure(TestError())]
        let viewModel = makeSUT(apiClient: client, container: container)

        await viewModel.refreshWatchlist()

        XCTAssertNotNil(viewModel.watchlistErrorMessage)
        XCTAssertNil(viewModel.watchlistUpdatedAt)
        XCTAssertEqual(try savedPools(in: container).first?.apy, 4)
    }

    func testRefreshEmptyWatchlistSendsNoRequests() async throws {
        let client = MockDeFiAPIClient()
        let viewModel = makeSUT(apiClient: client, container: try makeContainer())

        await viewModel.refreshWatchlist()

        XCTAssertTrue(client.chartRequests.requested.isEmpty)
        XCTAssertNil(viewModel.watchlistErrorMessage)
    }
}
