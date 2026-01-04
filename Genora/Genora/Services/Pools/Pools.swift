//
//  ChainItem.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import Foundation

struct ChainItem: Codable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
}

