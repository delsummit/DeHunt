//
//  DashboardView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    metricsGrid
                }
                .padding()
                .task {
                    await viewModel.loadMetrics()
                }
            }
            .navigationTitle("Market overview")
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)
        }
    }
    
    @ViewBuilder
    private var metricsGrid: some View {
        VStack {
            ForEach(0..<(viewModel.metrics.count / 2), id: \.self) { rowIndex in
                metricRow(for: rowIndex)
            }
            
            // last card should be large if number is odd
            if viewModel.metrics.count % 2 != 0, let lastMetric = viewModel.metrics.last {
                lastMetricCard(lastMetric)
            }
        }
        .padding()
        .background(metricsBackground)
        .overlay(metricsBorder)
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
    DashboardView()
}

