//
//  BlockchainChain.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 06/01/2026.
//

import SwiftUI

struct ChainConfig {
    let name: String
    let trustWalletPath: String
    let apiNames: [String]
    
    init(_ name: String, tw: String? = nil, api: [String]? = nil) {
        self.name = name
        self.trustWalletPath = tw ?? name.lowercased()
        self.apiNames = api ?? [name]
    }
    
    var iconName: String {
        "\(name.prefix(1).lowercased()).circle.fill"
    }
}

enum BlockchainChain: String, CaseIterable, Identifiable {
    case ethereum = "Ethereum"
    case binance = "Binance"
    case polygon = "Polygon"
    case arbitrum = "Arbitrum"
    case optimism = "Optimism"
    case avalanche = "Avalanche"
    case fantom = "Fantom"
    case solana = "Solana"
    case base = "Base"
    case tron = "Tron"
    case aptos = "Aptos"
    case plasma = "Plasma"
    case hyperliquid = "Hyperliquid L1"
    case sui = "Sui"
    case ton = "TON"
    
    var id: String { rawValue }
    
    // tw - trust wallet
    private static let configs: [BlockchainChain: ChainConfig] = [
        .ethereum: ChainConfig("Ethereum", tw: "ethereum", api: ["Ethereum"]),
        .binance: ChainConfig("Binance", tw: "smartchain", api: ["Binance", "BSC"]),
        .polygon: ChainConfig("Polygon", tw: "polygon", api: ["Polygon"]),
        .arbitrum: ChainConfig("Arbitrum", tw: "arbitrum", api: ["Arbitrum"]),
        .optimism: ChainConfig("Optimism", tw: "optimism", api: ["Optimism"]),
        .avalanche: ChainConfig("Avalanche", tw: "avalanchec", api: ["Avalanche"]),
        .fantom: ChainConfig("Fantom", tw: "fantom", api: ["Fantom"]),
        .solana: ChainConfig("Solana", tw: "solana", api: ["Solana"]),
        .base: ChainConfig("Base", tw: "base", api: ["Base"]),
        .tron: ChainConfig("Tron", tw: "tron", api: ["Tron"]),
        .aptos: ChainConfig("Aptos", tw: "aptos", api: ["Aptos"]),
        .plasma: ChainConfig("Plasma", tw: "plasma", api: ["Plasma"]),
        .hyperliquid: ChainConfig("Hyperliquid L1", tw: "hyperliquid", api: ["Hyperliquid"]),
        .sui: ChainConfig("Sui", tw: "sui", api: ["Sui"]),
        .ton: ChainConfig("TON", tw: "ton", api: ["TON", "Ton"])
    ]
    
    private var config: ChainConfig {
        guard let config = Self.configs[self] else {
            fatalError("Missing config for chain: \(self.rawValue)")
        }
        return config
    }
    
    var trustWalletIconURL: URL? {
        if self == .hyperliquid {
            return URL(string: "https://icons.llamao.fi/icons/chains/rsz_hyperliquid-l1.jpg")
        }
        
        let baseURL = "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains"
        return URL(string: "\(baseURL)/\(config.trustWalletPath)/info/logo.png")
    }
    
    // placeholder
    var iconName: String {
        config.iconName
    }
    
    var color: Color {
        return .accentColor
    }
    
    // MARK: - for DefiLlama API
    
    var apiChainNames: [String] {
        config.apiNames
    }
    
    func matches(apiChainName: String) -> Bool {
        return apiChainNames.contains(apiChainName)
    }
}

extension BlockchainChain: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    static func == (lhs: BlockchainChain, rhs: BlockchainChain) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
