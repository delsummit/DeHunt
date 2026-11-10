//
//  ServicesTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

final class ServicesTests: XCTestCase {

    func testYieldPoolServiceRequestsPoolsAndUnwrapsData() async throws {
        let url = "https://yields.llama.fi/pools"
        let api = MockAPIService(responses: [url: Data(json: """
        {"status": "success", "data": [
          {"pool": "p1", "chain": "OP Mainnet", "project": "velodrome", "symbol": "USDC-WETH", "tvlUsd": 3500000, "apy": 18.4, "stablecoin": false},
          {"pool": "p2", "chain": "Hyperliquid L1", "project": "hyperliquid-hlp", "symbol": "USDC", "tvlUsd": 400000000, "apy": 9.1}
        ]}
        """)])

        let pools = try await YieldPoolService(apiService: api).fetchYieldPools()

        XCTAssertEqual(api.requestedURLs, [url])
        XCTAssertEqual(pools.map(\.pool), ["p1", "p2"])
        XCTAssertEqual(pools.first?.chain, "OP Mainnet")
        XCTAssertEqual(pools.first?.apy, 18.4)
    }

    func testYieldPoolServicePassesErrorsThrough() async {
        let service = YieldPoolService(apiService: MockAPIService(responses: [:]))

        do {
            _ = try await service.fetchYieldPools()
            XCTFail("Expected an error")
        } catch {
            XCTAssertEqual(error as? LlamaAPIError, .invalidResponse)
        }
    }

    func testProtocolsServiceDecodesOptionalFields() async throws {
        let url = "https://api.llama.fi/protocols"
        let api = MockAPIService(responses: [url: Data(json: """
        [
          {"id": "1", "name": "Aave V3", "symbol": "AAVE", "category": "Lending", "chains": ["Ethereum", "Arbitrum"],
           "tvl": 25000000000, "chainTvls": {"Ethereum": 20000000000, "Arbitrum": 5000000000}, "change_1d": 0.8, "change_7d": -1.2},
          {"id": "2", "name": "New Protocol", "symbol": null, "category": null, "chains": null, "tvl": null,
           "chainTvls": null, "change_1d": null, "change_7d": null}
        ]
        """)])

        let protocols = try await ProtocolsService(apiService: api).fetchProtocols()

        XCTAssertEqual(api.requestedURLs, [url])
        XCTAssertEqual(protocols.count, 2)
        XCTAssertEqual(protocols[0].chainTvls?["Arbitrum"], 5_000_000_000)
        XCTAssertNil(protocols[1].tvl)
        XCTAssertNil(protocols[1].category)
    }

    func testHistoricalTVLServiceRequestsChainTVLHistory() async throws {
        let url = "https://api.llama.fi/v2/historicalChainTvl"
        let api = MockAPIService(responses: [url: Data(json: """
        [{"date": 1762473600, "tvl": 151000000000}, {"date": 1762560000, "tvl": 152500000000.5}]
        """)])

        let history = try await HistoricalTVLService(apiService: api).fetchHistoricalTVL()

        XCTAssertEqual(api.requestedURLs, [url])
        XCTAssertEqual(history.map(\.date), [1762473600, 1762560000])
        XCTAssertEqual(history.last?.tvl, 152500000000.5)
    }

    func testPoolChartServiceRequestsPoolHistoryAndKeepsNulls() async throws {
        let url = "https://yields.llama.fi/chart/747c1d2a"
        let api = MockAPIService(responses: [url: Data(json: """
        {"status": "success", "data": [
          {"timestamp": "2022-05-03T00:00:00.000Z", "tvlUsd": 11074372760, "apy": null, "apyBase": null, "il7d": null},
          {"timestamp": "2026-11-08T13:01:23.604Z", "tvlUsd": 21682837091, "apy": 2.24679, "apyBase": 2.24679, "il7d": null}
        ]}
        """)])

        let history = try await PoolChartService(apiService: api).fetchPoolChart(poolId: "747c1d2a")

        XCTAssertEqual(api.requestedURLs, [url])
        XCTAssertEqual(history, [
            PoolChartPoint(tvlUsd: 11074372760, apy: nil),
            PoolChartPoint(tvlUsd: 21682837091, apy: 2.24679)
        ])
    }

    func testPoolChartServiceReturnsEmptyHistoryForUnknownPool() async throws {
        let url = "https://yields.llama.fi/chart/unknown"
        let api = MockAPIService(responses: [url: Data(json: #"{"status": "success", "data": []}"#)])

        let history = try await PoolChartService(apiService: api).fetchPoolChart(poolId: "unknown")

        XCTAssertTrue(history.isEmpty)
    }

    func testAPIClientRoutesEachCallToItsService() async throws {
        let api = MockAPIService(responses: [
            "https://api.llama.fi/protocols": Data(json: "[]"),
            "https://api.llama.fi/v2/historicalChainTvl": Data(json: "[]"),
            "https://yields.llama.fi/pools": Data(json: #"{"status": "success", "data": []}"#),
            "https://yields.llama.fi/chart/p1": Data(json: #"{"status": "success", "data": []}"#)
        ])
        let client = DeFiAPIClient(
            protocols: ProtocolsService(apiService: api),
            tvl: HistoricalTVLService(apiService: api),
            yieldPools: YieldPoolService(apiService: api),
            poolCharts: PoolChartService(apiService: api)
        )

        _ = try await client.fetchProtocols()
        _ = try await client.fetchHistoricalTVL()
        _ = try await client.fetchYieldPools()
        _ = try await client.fetchPoolChart(poolId: "p1")

        XCTAssertEqual(api.requestedURLs, [
            "https://api.llama.fi/protocols",
            "https://api.llama.fi/v2/historicalChainTvl",
            "https://yields.llama.fi/pools",
            "https://yields.llama.fi/chart/p1"
        ])
    }
}
