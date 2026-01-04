//
//  HistoricalTVLProcessor.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 21/12/2025.
//

import Foundation

struct HistoricalTVLProcessor {
    
    func process(_ rawData: [HistoricalTVL], days: Int = 7) -> [HistoricalTVL] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        let filteredData = rawData
            .filter { item in
                let itemDate = Date(timeIntervalSince1970: TimeInterval(item.date))
                return itemDate >= cutoffDate
            }
            .sorted { $0.date < $1.date }
        
        if filteredData.count < 20 {
            return interpolateData(filteredData, targetPoints: 30)
        }
        
        return filteredData
    }
    
    // MARK: - Interpolation
    
    private func interpolateData(_ data: [HistoricalTVL], targetPoints: Int) -> [HistoricalTVL] {
        guard data.count >= 2 else { return data }
        
        var result: [HistoricalTVL] = []
        
        for i in 0..<(data.count - 1) {
            let current = data[i]
            let next = data[i + 1]
            
            result.append(current)
            
            let pointsBetween = targetPoints / data.count
            let timeDiff = next.date - current.date
            let tvlDiff = next.tvl - current.tvl
            
            for j in 1..<pointsBetween {
                let ratio = Double(j) / Double(pointsBetween)
                let interpolatedDate = current.date + Int(Double(timeDiff) * ratio)
                let interpolatedTVL = current.tvl + (tvlDiff * ratio)
                
                result.append(HistoricalTVL(
                    date: interpolatedDate,
                    tvl: interpolatedTVL
                ))
            }
        }
        
        if let last = data.last {
            result.append(last)
        }
        
        return result
    }
    
    func calculateStats(from data: [HistoricalTVL]) -> TVLStats {
        guard !data.isEmpty else {
            return TVLStats(min: 0, max: 0, current: 0, change: 0)
        }
        
        let min = data.map(\.tvl).min() ?? 0
        let max = data.map(\.tvl).max() ?? 0
        let current = data.last?.tvl ?? 0
        
        let change = calculateChange(from: data)
        
        return TVLStats(min: min, max: max, current: current, change: change)
    }
    
    // MARK: - Private
    
    private func calculateChange(from data: [HistoricalTVL]) -> Double {
        guard data.count >= 2,
              let first = data.first?.tvl,
              first > 0 else {
            return 0
        }
        
        let last = data.last?.tvl ?? 0
        return ((last - first) / first) * 100
    }
}

// MARK: - Stats Model

struct TVLStats {
    let min: Double
    let max: Double
    let current: Double
    let change: Double
}
