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
                
                defiLlamaMention
            }
            .background(Color.backgroundPrimary.ignoresSafeArea())
            .navigationTitle("Strategies")
            .navigationDestination(isPresented: $viewModel.shouldShowResults) {
                StrategiesSearchResultView(pools: viewModel.filteredPools, viewModel: viewModel)
            }
        
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        // fav pools hash
                    } label: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.element)
                    }
                }
                
                if focusedField != nil {
                    ToolbarItem {
                        Button("Done") {
                            withAnimation(.smooth) {
                                focusedField = nil
                            }
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .animation(.smooth, value: focusedField)
            .onTapGesture {
                focusedField = nil
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
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    Text(viewModel.isLoading ? "Searching..." : "Search pools")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.glassProminent)
            .tint(.backgroundSecondary)
            .disabled(viewModel.isLoading)
            
            if let errorMessage = viewModel.errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.accentRed)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
    
    private var defiLlamaMention: some View {
        HStack {
            Image("defillama")
                .resizable()
                .saturation(0)
                .colorMultiply(Color.textPrimary)
                .frame(width: 100, height: 100)
            
            VStack {
                Text("Powered by")
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
                Text("DefiLlama")
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
            }
        }
        .padding()
    }
}

#Preview {
    StrategiesView()
}
