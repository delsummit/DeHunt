//
//  DashboardView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct DashboardView: View {
    // mock data
    @State private var metrics: [DashboardMetric] = [
        .tvl(value: 55.3, changePercent: 12.5),
        .activeStrategies(count: 200, newCount: 12),
        .volume(value: 12.8, changePercent: 8.3),
        .activeUsers(count: 1234147, todayCount: 156),
        .averageAPY(percent: 18.5, changePercent: 2.1),
        .totalRewards(value: 2.4, recentChange: 120)
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(metrics) { metric in
                        DashboardCard(
                            title: metric.title,
                            value: metric.valueText,
                            subtitle: metric.subtitleText
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Market overview")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundPrimary)
        }
    }
}
#Preview {
    DashboardView()
}
