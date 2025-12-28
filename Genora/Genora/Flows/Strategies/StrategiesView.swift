//
//  StrategiesView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct StrategiesView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Strategies")
            .navigationBarTitleDisplayMode(.inline)
            .background(.backgroundPrimary)
        }
    }
}

#Preview {
    StrategiesView()
}
