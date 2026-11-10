//
//  BlockchainChainTests.swift
//  DeHuntTests
//
//  Created by Rostyslav Mukoida on 10/11/2026.
//

import XCTest
@testable import DeHunt

@MainActor
final class BlockchainChainTests: XCTestCase {

    private let currentDefiLlamaNames: [BlockchainChain: String] = [
        .ethereum: "Ethereum",
        .binance: "BSC",
        .polygon: "Polygon",
        .arbitrum: "Arbitrum",
        .optimism: "OP Mainnet",
        .avalanche: "Avalanche",
        .fantom: "Fantom",
        .solana: "Solana",
        .base: "Base",
        .tron: "Tron",
        .aptos: "Aptos",
        .plasma: "Plasma",
        .hyperliquid: "Hyperliquid L1",
        .sui: "Sui",
        .ton: "TON"
    ]

    func testEveryChainHasACurrentDefiLlamaName() {
        XCTAssertEqual(Set(currentDefiLlamaNames.keys), Set(BlockchainChain.allCases))
    }

    func testEachDefiLlamaNameMatchesExactlyItsChain() {
        for (chain, apiName) in currentDefiLlamaNames {
            let matches = BlockchainChain.allCases.filter { $0.matches(apiChainName: apiName) }
            XCTAssertEqual(matches, [chain], "\"\(apiName)\" should match only \(chain)")
        }
    }

    func testUnsupportedChainMatchesNothing() {
        XCTAssertTrue(BlockchainChain.allCases.allSatisfy { !$0.matches(apiChainName: "Cardano") })
    }
}
