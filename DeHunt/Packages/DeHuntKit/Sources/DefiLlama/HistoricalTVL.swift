//
//  HistoricalTVL.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 20/12/2025.
//

import Foundation

// MARK: - Model
public struct HistoricalTVL: Codable, Identifiable, Sendable {
    public var id: Int { date }
    public let date: Int
    public let tvl: Double
    
    public var dateValue: Date {
        Date(timeIntervalSince1970: TimeInterval(date))
    }
    
    public init(date: Int, tvl: Double) {
        self.date = date
        self.tvl = tvl
    }
}
