//
//  DashboardCalculationTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

@MainActor
final class MarketOverviewMetricsCalculatorTests: XCTestCase {

    func testSkipsSmallAndExcludedProtocols() {
        let calculator = MarketOverviewMetricsCalculator(minTVL: 100, excludedCategories: ["CEX"])
        let protocols: [ProtocolsTVL] = [
            .fixture(id: "1", name: "Aave", category: "Lending", tvl: 300, change1d: 2),
            .fixture(id: "2", name: "Lido", category: nil, tvl: 100, change1d: -1),
            .fixture(id: "3", name: "Tiny", category: "Dexs", tvl: 99, change1d: 50),
            .fixture(id: "4", name: "Binance", category: "CEX", tvl: 10_000, change1d: 50),
            .fixture(id: "5", name: "Unknown", category: "Dexs", tvl: nil, change1d: 50)
        ]

        let metrics = calculator.calculate(from: protocols)

        guard case let .tvl(total, change) = metrics.first else {
            return XCTFail("Expected the TVL metric first, got \(metrics)")
        }
        XCTAssertEqual(total, 400, "Only Aave (300) and Lido (100, no category) count")
        XCTAssertEqual(change, (300 * 2 + 100 * -1) / 400, accuracy: 0.0001, "Change is weighted by TVL")
    }

    func testTopProtocolIsTheLargestByTVL() {
        let calculator = MarketOverviewMetricsCalculator(minTVL: 0, excludedCategories: [])
        let protocols: [ProtocolsTVL] = [
            .fixture(id: "1", name: "Aave", tvl: 300, change1d: 2),
            .fixture(id: "2", name: "Lido", tvl: 500, change1d: -1)
        ]

        let metrics = calculator.calculate(from: protocols)

        guard metrics.count == 3, case let .topProtocol(name, tvl, change) = metrics[1] else {
            return XCTFail("Expected the top protocol metric second, got \(metrics)")
        }
        XCTAssertEqual(name, "Lido")
        XCTAssertEqual(tvl, 500)
        XCTAssertEqual(change, -1)
    }

    func testNothingLeftAfterFilteringReturnsNoMetrics() {
        let calculator = MarketOverviewMetricsCalculator(minTVL: 1_000, excludedCategories: [])

        XCTAssertTrue(calculator.calculate(from: [.fixture(tvl: 999)]).isEmpty)
        XCTAssertTrue(calculator.calculate(from: []).isEmpty)
    }
}

@MainActor
final class HistoricalTVLProcessorTests: XCTestCase {

    private let day = 86_400
    private var now: Int { Int(Date.now.timeIntervalSince1970) }

    func testKeepsOnlyTheLastDaysSortedByDate() {
        let raw = (0..<40).map { HistoricalTVL(date: now - $0 * day, tvl: Double($0)) }.shuffled()

        let processed = HistoricalTVLProcessor().process(raw, days: 30)

        XCTAssertTrue(processed.allSatisfy { $0.date >= now - 30 * day - 60 })
        XCTAssertEqual(processed.map(\.date), processed.map(\.date).sorted())
        XCTAssertGreaterThanOrEqual(processed.count, 20, "Enough points, so no interpolation")
    }

    func testInterpolatesWhenThereAreFewPoints() {
        let first = HistoricalTVL(date: now - 2 * day, tvl: 100)
        let last = HistoricalTVL(date: now - day, tvl: 200)

        let processed = HistoricalTVLProcessor().process([last, first], days: 7)

        XCTAssertGreaterThan(processed.count, 2)
        XCTAssertEqual(processed.first?.date, first.date)
        XCTAssertEqual(processed.last?.date, last.date)
        XCTAssertEqual(processed.map(\.date), processed.map(\.date).sorted())
        XCTAssertTrue(processed.allSatisfy { (100...200).contains($0.tvl) }, "Interpolated values stay between the ends")
    }

    func testStatsReportRangeCurrentValueAndChange() {
        let data = [
            HistoricalTVL(date: 1, tvl: 200),
            HistoricalTVL(date: 2, tvl: 150),
            HistoricalTVL(date: 3, tvl: 250)
        ]

        let stats = HistoricalTVLProcessor().calculateStats(from: data)

        XCTAssertEqual(stats.min, 150)
        XCTAssertEqual(stats.max, 250)
        XCTAssertEqual(stats.current, 250)
        XCTAssertEqual(stats.change, 25, accuracy: 0.0001, "200 → 250 is +25%")
    }

    func testStatsOfEmptyDataAreZero() {
        let stats = HistoricalTVLProcessor().calculateStats(from: [])

        XCTAssertEqual(stats.current, 0)
        XCTAssertEqual(stats.change, 0)
    }
}
