//
//  StrategiesViewModelTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 18/01/2026.
//

import XCTest
@testable import DeHunt

// MARK: - Mock API Client
final class MockDeFiAPIClient: DeFiAPIClientProtocol {
    var protocols: ProtocolsServiceProtocol { fatalError("Not used") }
    var tvl: HistoricalTVLServiceProtocol { fatalError("Not used") }
    var yieldPools: YieldPoolServiceProtocol { fatalError("Not used") }
    
    func fetchYieldPools() async throws -> [YieldPool] { [] }
    func fetchProtocols() async throws -> [ProtocolsTVL] { [] }
    func fetchHistoricalTVL() async throws -> [HistoricalTVL] { [] }
}

@MainActor
final class StrategiesViewModelTests: XCTestCase {
    var viewModel: StrategiesViewModel!
    var mockAPIClient: MockDeFiAPIClient!
    
    override func setUp() {
        mockAPIClient = MockDeFiAPIClient()
        viewModel = StrategiesViewModel(apiClient: mockAPIClient)
    }
    
    func testFilterPoolsByAPY() {
        // ARRANGE
        viewModel.minimumAPY = 15.0
        
        let testPools = [
            YieldPool(
                pool: "pool-1",
                chain: "Ethereum",
                project: "Uniswap",
                symbol: "ETH-USDC",
                tvlUsd: 1_000_000,
                apy: 25.0

            ),
            YieldPool(
                pool: "pool-2",
                chain: "Polygon",
                project: "QuickSwap",
                symbol: "MATIC-USDC",
                tvlUsd: 500_000,
                apy: 10.0
            ),
            YieldPool(
                pool: "pool-3",
                chain: "Arbitrum",
                project: "Camelot",
                symbol: "ARB-ETH",
                tvlUsd: 750_000,
                apy: 15.0
            )
        ]
        
        // ACT
        let filteredPools = viewModel.filterPoolsByAPY(testPools)
        
        // ASSERT
        XCTAssertEqual(filteredPools.count, 2)
        
        XCTAssertTrue(filteredPools.allSatisfy { $0.apy >= 15.0 })
        
        XCTAssertTrue(filteredPools.contains { $0.pool == "pool-1" })
        
        XCTAssertTrue(filteredPools.contains { $0.pool == "pool-3" })
        
        XCTAssertFalse(filteredPools.contains { $0.pool == "pool-2" })
    }
}
