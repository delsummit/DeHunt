//
//  HistoricalTVL.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 20/12/2025.
//

import Foundation

// MARK: - Model
struct HistoricalTVL: Codable, Identifiable {
    var id: Int { date }
    let date: Int
    let tvl: Double
    
    var dateValue: Date {
        Date(timeIntervalSince1970: TimeInterval(date))
    }
}
