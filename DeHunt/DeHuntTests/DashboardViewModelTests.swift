//
//  DashboardViewModelTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

@MainActor
final class DashboardViewModelTests: XCTestCase {

    private func makeSUT(apiClient: MockDeFiAPIClient) -> DashboardViewModel {
        DashboardViewModel(
            apiClient: apiClient,
            calculator: MarketOverviewMetricsCalculator(),
            tvlProcessor: HistoricalTVLProcessor()
        )
    }

    private func recentTVLHistory(days: Int) -> [HistoricalTVL] {
        let now = Int(Date.now.timeIntervalSince1970)
        return (0..<days).map { HistoricalTVL(date: now - $0 * 86_400, tvl: 100 + Double($0)) }
    }

    func testLoadDashboardDataFillsMetricsAndChart() async {
        var client = MockDeFiAPIClient()
        client.protocols = .success([.fixture()])
        client.historicalTVL = .success(recentTVLHistory(days: 30))
        let viewModel = makeSUT(apiClient: client)

        await viewModel.loadDashboardData()

        XCTAssertEqual(viewModel.metrics.map(\.id), ["tvl", "topProtocol", "topChain"])
        XCTAssertFalse(viewModel.historicalData.isEmpty)
        XCTAssertNil(viewModel.metricsErrorMessage)
        XCTAssertNil(viewModel.tvlErrorMessage)
        XCTAssertFalse(viewModel.isLoadingMetrics)
        XCTAssertFalse(viewModel.isLoadingTVL)
    }

    func testEachSectionFailsOnItsOwn() async {
        var client = MockDeFiAPIClient()
        client.protocols = .failure(LlamaAPIError.invalidData)
        client.historicalTVL = .success(recentTVLHistory(days: 30))
        let viewModel = makeSUT(apiClient: client)

        await viewModel.loadDashboardData()

        XCTAssertEqual(viewModel.metricsErrorMessage, "Invalid data")
        XCTAssertTrue(viewModel.metrics.isEmpty)
        XCTAssertNil(viewModel.tvlErrorMessage, "The chart still loads when the metrics fail")
        XCTAssertFalse(viewModel.historicalData.isEmpty)
        XCTAssertFalse(viewModel.isLoadingMetrics)
    }

    func testTVLErrorIsShownAndLoadingStops() async {
        var client = MockDeFiAPIClient()
        client.protocols = .success([.fixture()])
        client.historicalTVL = .failure(LlamaAPIError.invalidResponse)
        let viewModel = makeSUT(apiClient: client)

        await viewModel.loadDashboardData()

        XCTAssertEqual(viewModel.tvlErrorMessage, "Invalid response")
        XCTAssertFalse(viewModel.isLoadingTVL)
    }

    func testNoQualifyingProtocolsShowsNoData() async {
        var client = MockDeFiAPIClient()
        client.protocols = .success([.fixture(tvl: 1)])
        let viewModel = makeSUT(apiClient: client)

        await viewModel.loadMetrics()

        XCTAssertEqual(viewModel.metricsErrorMessage, "No data available")
    }
}
