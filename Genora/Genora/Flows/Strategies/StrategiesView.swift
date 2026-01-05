//
//  StrategiesView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct StrategiesView: View {
    @State private var selectedChains: Set<YieldPool> = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    StrategiesUserInputMoneyView()

                    Divider()
                        .frame(height: 20)
                    
                    StrategiesSelectedChainsView(selection: $selectedChains)
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
            .hideKeyboard()
            .navigationTitle("Strategies")
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)
        }
    }
}

#Preview {
    StrategiesView()
}
