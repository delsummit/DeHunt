//
//  DashboardView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct DashboardView: View {
    // mock data
    @State private var metrics: [MarketOverviewMetric] = [
        .tvl(value: 55.3, changePercent: 12.5),
        .activeStrategies(count: 200, newCount: 12),
        .averageAPY(percent: 18.5, changePercent: 2.1),
        .topProtocol(name: "Aave", tvl: 12.8, changePercent: 8.3),
        .topChain(name: "Ethereum", tvl: 45.2, changePercent: 5.7),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        ForEach(0..<(metrics.count / 2), id: \.self) { rowIndex in
                            HStack {
                                let leftIndex = rowIndex * 2
                                let rightIndex = leftIndex + 1
                                
                                MarketOverviewCard(
                                    title: metrics[leftIndex].title,
                                    value: metrics[leftIndex].valueText,
                                    subtitle: metrics[leftIndex].subtitleText
                                )
                                
                                MarketOverviewCard(
                                    title: metrics[rightIndex].title,
                                    value: metrics[rightIndex].valueText,
                                    subtitle: metrics[rightIndex].subtitleText
                                )
                            }
                        }
                        
                        // last card should be large if number is odd
                        if metrics.count % 2 != 0 {
                            MarketOverviewCard(
                                title: metrics.last!.title,
                                value: metrics.last!.valueText,
                                subtitle: metrics.last!.subtitleText
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.backgroundSecondary)
                            .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.border.opacity(0.4), lineWidth: 1)
                    )
                }
                .padding()
            }
            .navigationTitle("Market overview")
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)
        }
    }
}
#Preview {
    DashboardView()
}
