//
//  HistoricalTVL.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 20/12/2025.
//

import Foundation

// MARK: - Model
nonisolated struct HistoricalTVL: Codable, Identifiable, Sendable {
    var id: Int { date }
    let date: Int
    let tvl: Double
    
    var dateValue: Date {
        Date(timeIntervalSince1970: TimeInterval(date))
    }
}
