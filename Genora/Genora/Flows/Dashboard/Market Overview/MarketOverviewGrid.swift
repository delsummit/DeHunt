//
//  MarketOverviewGrid.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 18/12/2025.
//

import SwiftUI

struct MarketOverviewGrid: View {
    let viewModel: DashboardViewModel
    
    var body: some View {
        VStack (spacing: 8) {
            Text("Overview")
                .font(.headline)
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if viewModel.isLoadingMetrics {
                    skeletonContent
                } else if let errorMessage = viewModel.metricsErrorMessage {
                    errorView(errorMessage)
                } else if !viewModel.metrics.isEmpty {
                    metricsContent
                }
            }
        }
        .padding()
        .background(metricsBackground)
        .overlay(metricsBorder)
    }
    
    @ViewBuilder
    private var metricsContent: some View {
        ForEach(0..<(viewModel.metrics.count / 2), id: \.self) { rowIndex in
            metricRow(for: rowIndex)
        }
        
        if viewModel.metrics.count % 2 != 0, let lastMetric = viewModel.metrics.last {
            lastMetricCard(lastMetric)
        }
    }
    
    private var skeletonContent: some View {
        ForEach(0..<2, id: \.self) { _ in
            HStack {
                MarketOverviewCardSkeleton()
                MarketOverviewCardSkeleton()
            }
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32))
                .foregroundStyle(.accentRed)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private func metricRow(for rowIndex: Int) -> some View {
        let leftIndex = rowIndex * 2
        let rightIndex = leftIndex + 1
        
        return HStack {
            MarketOverviewCard(
                metric: viewModel.metrics[leftIndex]
            )
            
            MarketOverviewCard(
                metric: viewModel.metrics[rightIndex]
            )
        }
    }
    
    private func lastMetricCard(_ metric: MarketOverviewMetric) -> some View {
        MarketOverviewCard(
            metric: metric
        )
        .frame(maxWidth: .infinity)
    }
    
    private var metricsBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.backgroundSecondary)
            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
    
    private var metricsBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.border.opacity(0.4), lineWidth: 1)
    }
}

#Preview {
    let mockRepo = MockDeFiRepository()
    let calculator = MetricsCalculator()
    let processor = HistoricalTVLProcessor()
    let viewModel = DashboardViewModel(
        repository: mockRepo,
        calculator: calculator,
        tvlProcessor: processor
    )
    
    MarketOverviewGrid(viewModel: viewModel)
        .task {
            await viewModel.loadMetrics()
        }
}
