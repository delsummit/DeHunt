//
//  StrategiesSelectedChainsView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 03/01/2026.
//

import SwiftUI

struct StrategiesSelectedChainsView: View {
    @State private var viewModel = StrategiesViewModel()
    @Binding var selection: Set<YieldPool>
    
    var body: some View {
        Text("Mark preferred chains")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        
        HStack {
            HStack {
                headerView
                
                Spacer()
            }
            .frame(minHeight: 60)
            .padding(.horizontal)
            .glassEffect()
            
            Button(action: {
                Task {
                    await viewModel.loadYieldPools()
                }
            }) {
                Image(systemName: "square.and.pencil")
                    .frame(width: 40)
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.glass)
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        if selection.isEmpty {
            Text("No chains selected")
                .foregroundStyle(.secondary)
        } else {
            HStack(spacing: 0) {
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        //.font(.largeTitle)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}


#Preview {
    StrategiesView()
}
