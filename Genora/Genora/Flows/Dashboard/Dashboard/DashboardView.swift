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
                VStack(spacing: 20) {
                    VStack {
                        MarketOverviewGrid(viewModel: viewModel)
                        Text("*data includes only DeFi protocols")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                    }
                    
                    VStack {
                        TVLChartView(viewModel: viewModel)
                        Text("*excludes liquid staking and double counted TVL")
                            .font(.subheadline)
                            .foregroundStyle(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                    }
                }
                .padding()
                .task {
                    await viewModel.loadDashboardData()
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)
        }
    }
}

#Preview {
    DashboardView()
}

