//
//  StrategiesSelectedChainsView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 03/01/2026.
//

import SwiftUI

struct StrategiesChainSelectionView: View {
    @Bindable var viewModel: StrategiesViewModel
    
    var body: some View {
        Text("Mark preferred chains")
            .font(.headline)
            .foregroundStyle(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            HStack {
                headerView
                
                Spacer()
            }
            .frame(minHeight: 60)
            .padding(.horizontal)
            .glassEffect(.regular, in: .rect(cornerRadius: 16))

            Button(action: {
                HapticsEngine.shared.lightTap()
                viewModel.toggleChainSelection()
            }) {
                Image(systemName: "square.and.pencil")
                    .frame(width: 40)
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.glass)
        }
        .sheet(isPresented: $viewModel.isChainSelectionPresented) {
            StrategiesChainSelectionSheetView(viewModel: viewModel)
                .presentationDetents([.large])
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        if !viewModel.hasSelectedChains {
            Text("Default: all chains")
                .foregroundStyle(.textSecondary)
        } else {
            ChainIconStackView(
                chains: viewModel.selectedChainsArray,
                maxVisible: 7,
                iconSize: 32,
                overlapOffset: -8
            )
        }
    }
}


#Preview {
    StrategiesView()
}
