//
//  HistoricalTVL.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 20/12/2025.
//

import Foundation

// MARK: - Model
struct HistoricalTVL: Codable, Identifiable {
    var id: String
    let date: Int
    let tvl: Int
    
    var dateValue: Date {
        Date(timeIntervalSince1970: TimeInterval(date))
    }
    
    init(id: String, date: Int, tvl: Int) {
        self.id = id
        self.date = date
        self.tvl = tvl
    }
}

// MARK: - API Response Model
struct HistoricalTVLResponse: Codable {
    let date: Int
    let tvl: Double
}
