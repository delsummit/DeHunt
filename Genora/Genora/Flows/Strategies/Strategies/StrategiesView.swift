//
//  StrategiesView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct StrategiesView: View {
    @State private var viewModel = StrategiesViewModel()
    
    enum FocusedField {
        case investmentAmount
        case minTVL
        case minimumAPY
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                content
                
                searchButton
            }
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("Strategies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if focusedField != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            focusedField = nil
                        }
                        .foregroundStyle(.element)
                        .fontWeight(.semibold)
                    }
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            .onAppear {
                HapticsEngine.shared.prepareHaptics()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack {
            StrategiesUserInputMoneyView(viewModel: viewModel, focusedField: $focusedField)
            
            Divider()
                .frame(height: 20)
            
            StrategiesMinTVLView(viewModel: viewModel, focusedField: $focusedField)
            
            Divider()
                .frame(height: 20)
            
            StrategiesChainSelectionView(viewModel: viewModel)
            
            Divider()
                .frame(height: 20)
            
            StrategiesAPYSliderView(viewModel: viewModel, focusedField: $focusedField)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.backgroundSecondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0), lineWidth: 1)
        )
        .padding()
    }
    
    private var searchButton: some View {
        VStack(spacing: 12) {
            Button(action: {
                Task {
                    await viewModel.performSearch()
                }
            }) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    Text("Search pools")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.glassProminent)
            .tint(.backgroundSecondary)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StrategiesView()
}
