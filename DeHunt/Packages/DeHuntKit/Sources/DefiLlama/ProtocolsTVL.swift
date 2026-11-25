//
//  ProtocolsTVL.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 17/12/2025.
//

import Foundation

public struct ProtocolsTVL: Decodable, Sendable {
    let id: String
    public let name: String
    let symbol: String?
    public let category: String?
    public let chains: [String]?
    public let tvl: Double?
    let chainTvls: [String: Double]?
    public let change_1d: Double?
    let change_7d: Double?
}
