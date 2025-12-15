//
//  DashboardView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Hello!")
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.backgroundPrimary)
        }
    }
}

#Preview {
    DashboardView()
}
