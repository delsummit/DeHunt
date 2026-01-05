//
//  DashboardViewModel.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 18/12/2025.
//

import Foundation
import Observation

@Observable
@MainActor
final class DashboardViewModel {
    
    // MARK: - State
    
    // Market Overview
    var metrics: [MarketOverviewMetric] = []
    var metricsErrorMessage: String?
    var isLoadingMetrics = true
    
    // TVL Chart
    var historicalData: [HistoricalTVL] = []
    var tvlStats: TVLStats = TVLStats(min: 0, max: 0, current: 0, change: 0)
    var tvlErrorMessage: String?
    var isLoadingTVL = true
    
    // MARK: - Dependencies
    private let apiClient: DeFiAPIClientProtocol
    private let calculator: MarketOverviewMetricsCalculator
    private let tvlProcessor: HistoricalTVLProcessor
    
    init(
        apiClient: DeFiAPIClientProtocol,
        calculator: MarketOverviewMetricsCalculator,
        tvlProcessor: HistoricalTVLProcessor
    ) {
        self.apiClient = apiClient
        self.calculator = calculator
        self.tvlProcessor = tvlProcessor
    }
    
    convenience init() {
        self.init(
            apiClient: DeFiAPIClient(),
            calculator: MarketOverviewMetricsCalculator(),
            tvlProcessor: HistoricalTVLProcessor()
        )
    }
    
    // MARK: - Public Methods
    func loadDashboardData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.loadMetrics()
            }
            
            group.addTask {
                await self.loadHistoricalTVL()
            }
        }
    }
    
    func loadMetrics() async {
        metricsErrorMessage = nil
        
        do {
            let protocols = try await apiClient.fetchProtocols()
            
            metrics = calculator.calculate(from: protocols)
            
            if metrics.isEmpty {
                metricsErrorMessage = "No data available"
            }
            
        } catch LiamaAPIError.invalidURL {
            metricsErrorMessage = "Invalid URL"
        } catch LiamaAPIError.invalidResponse {
            metricsErrorMessage = "Invalid response"
        } catch LiamaAPIError.invalidData {
            metricsErrorMessage = "Invalid data"
        } catch {
            metricsErrorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isLoadingMetrics = false
    }
    
    func loadHistoricalTVL() async {
        tvlErrorMessage = nil
        
        do {
            let rawData = try await apiClient.fetchHistoricalTVL()
            
            historicalData = tvlProcessor.process(rawData, days: 14)
            tvlStats = tvlProcessor.calculateStats(from: historicalData)
            
        } catch LiamaAPIError.invalidURL {
            tvlErrorMessage = "Invalid URL"
        } catch LiamaAPIError.invalidResponse {
            tvlErrorMessage = "Invalid response"
        } catch LiamaAPIError.invalidData {
            tvlErrorMessage = "Invalid data"
        } catch {
            tvlErrorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isLoadingTVL = false
    }
}
