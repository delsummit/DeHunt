//
//  StrategiesChainSelectionSheetView.swift.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 06/01/2026.
//

import SwiftUI

struct StrategiesChainSelectionSheetView: View {
    @Bindable var viewModel: StrategiesViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Chains")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if viewModel.hasSelectedChains {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Selected (\(viewModel.selectedChainsCount))")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(viewModel.selectedChainsArray) { chain in
                                    ChainChip(
                                        chain: chain,
                                        isSelected: true,
                                        action: { viewModel.toggleChain(chain) }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(viewModel.availableChains) { chain in
                                ChainChip(
                                    chain: chain,
                                    isSelected: false,
                                    action: { viewModel.toggleChain(chain) }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear All") {
                        HapticsEngine.shared.milestone()
                        viewModel.clearAllChains()
                    }
                    .disabled(!viewModel.hasSelectedChains)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
