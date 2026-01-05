//
//  ProtocolsTVL.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 17/12/2025.
//

import Foundation

struct ProtocolsTVL: Decodable {
    let id: String
    let name: String
    let symbol: String?
    let category: String?
    let chains: [String]?
    let tvl: Double?
    let chainTvls: [String: Double]?
    let change_1d: Double?
    let change_7d: Double?
}
