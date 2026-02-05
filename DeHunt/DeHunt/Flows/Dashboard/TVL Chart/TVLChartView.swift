//
//  TVLChartView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 20/12/2025.
//

import SwiftUI
import Charts

struct TVLChartView: View {
    let viewModel: DashboardViewModel
    @State private var selectedDate: Date?
    @State private var selectedTVL: Double?
    @State private var lastHapticDate: Date?
    @State private var shouldPlayMilestone = false
    private let haptics = HapticsEngine.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            
            if viewModel.isLoadingTVL {
                chartSkeleton
            } else if let errorMessage = viewModel.tvlErrorMessage {
                errorView(errorMessage)
            } else if !viewModel.historicalData.isEmpty {
                chartSection
            }
        }
        .padding()
        .background(chartBackground)
        .onAppear {
            haptics.prepareHaptics()
        }
        
        .task(id: shouldPlayMilestone) {
            guard shouldPlayMilestone else { return }
            
            try? await Task.sleep(for: .milliseconds(100))
            haptics.milestone()
            shouldPlayMilestone = false
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("TVL Chart")
                .font(.headline)
                .foregroundStyle(.textPrimary)
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("\(displayedTVL.formatted(decimals: 2, currency: true))*")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.textPrimary)
                    .contentTransition(.numericText())
                    .animation(.smooth, value: displayedTVL)
                
                changeIndicator
            }
            
            if let date = displayedDate {
                Text(date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
                    .foregroundStyle(.textSecondary)
            }
        }
    }
    
    private var displayedDate: Date? {
        if let selectedDate = selectedDate, selectedTVL != nil {
            return selectedDate
        }
        return viewModel.historicalData.last?.dateValue
    }
    
    private var displayedTVL: Double {
        selectedTVL ?? viewModel.tvlStats.current
    }
    
    private var changeIndicator: some View {
        HStack(spacing: 4) {
            Image(systemName: viewModel.tvlStats.change >= 0 ? "arrow.up.right" : "arrow.down.right")
                .font(.system(size: 12, weight: .semibold))
            
            Text(String(format: "%.2f%%", abs(viewModel.tvlStats.change)))
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundStyle(viewModel.tvlStats.change >= 0 ? .textPositive : .textNegative)
    }
    
    // MARK: - Chart Section
    
    private var chartColor: Color {
        viewModel.tvlStats.change >= 0 ? .accentPrimary : .accentRed
    }
    
    private var yAxisDomain: ClosedRange<Double> {
        guard !viewModel.historicalData.isEmpty else {
            return 0...100
        }
        
        let minValue = viewModel.tvlStats.min
        let maxValue = viewModel.tvlStats.max
        let range = maxValue - minValue
        
        let padding = max(range * 0.1, 1)
        
        return (minValue - padding)...(maxValue + padding)
    }
    
    private var chartSection: some View {
        Chart(viewModel.historicalData) { item in
            LineMark(
                x: .value("Date", item.dateValue),
                y: .value("TVL", item.tvl)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [chartColor, chartColor.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .lineStyle(StrokeStyle(lineWidth: 2))
            .interpolationMethod(.cardinal)
            
            AreaMark(
                x: .value("Date", item.dateValue),
                yStart: .value("Min", yAxisDomain.lowerBound),
                yEnd: .value("TVL", item.tvl)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        chartColor.opacity(0.3),
                        chartColor.opacity(0.1),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.monotone)
            
            if let selectedDate = selectedDate, selectedTVL != nil {
                RuleMark(x: .value("Selected", selectedDate))
                    .foregroundStyle(.white.opacity(0.3))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
            }
        }
        .frame(height: 200)
        .chartYScale(domain: yAxisDomain)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.day().month(.abbreviated))
                            .font(.caption2)
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 4]))
                    .foregroundStyle(.textSecondary.opacity(0.2))
                
                AxisValueLabel {
                    if let tvl = value.as(Double.self) {
                        Text(tvl.formatted(decimals: 0))
                            .font(.caption2)
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .chartXSelection(value: $selectedDate)
        .chartXScale(domain: chartXDomain)
        .onChange(of: selectedDate) { oldValue, newValue in
            updateSelectedTVL(for: newValue)
        }
    }
    
    private var chartXDomain: ClosedRange<Date> {
        guard let firstDate = viewModel.historicalData.first?.dateValue,
              let lastDate = viewModel.historicalData.last?.dateValue else {
            return Date()...Date()
        }
        return firstDate...lastDate
    }
    
    private func updateSelectedTVL(for date: Date?) {
        guard let date = date,
              let firstDate = viewModel.historicalData.first?.dateValue,
              let lastDate = viewModel.historicalData.last?.dateValue,
              date >= firstDate && date <= lastDate else {
            selectedTVL = nil
            selectedDate = nil
            lastHapticDate = nil
            return
        }
        
        // closest point (to show data while dragging chart)
        let closestData = viewModel.historicalData.min(by: { data1, data2 in
            abs(data1.dateValue.timeIntervalSince(date)) < abs(data2.dateValue.timeIntervalSince(date))
        })
        
        selectedTVL = closestData?.tvl
        
        triggerHapticsForSelection(date: date, tvl: closestData?.tvl)
    }
    
    private func triggerHapticsForSelection(date: Date?, tvl: Double?) {
        guard let date = date, let tvl = tvl else { return }
        
            // haptics change interval
        if let lastDate = lastHapticDate,
           abs(date.timeIntervalSince(lastDate)) < 14400 { // 4 hours
            return
        }
        
        lastHapticDate = date
        
        haptics.lightTap()
        
        if tvl == viewModel.tvlStats.min || tvl == viewModel.tvlStats.max {
            shouldPlayMilestone = true
        }
    }
    
    // MARK: - Skeleton
    
    private var chartSkeleton: some View {
        SkeletonView(RoundedRectangle(cornerRadius: 8), .backgroundTertiary)
            .frame(height: 200)
    }
    
    // MARK: - Error View
    
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
        .frame(height: 200)
    }
    
    // MARK: - Styling
    
    private var chartBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.backgroundSecondary)
            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
    }
    
    private var chartBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.border.opacity(0.4), lineWidth: 1)
    }
}

#Preview {
    let viewModel = DashboardViewModel()
    
    TVLChartView(viewModel: viewModel)
        .padding()
        .background(.backgroundPrimary)
        .task {
            await viewModel.loadHistoricalTVL()
        }
}
