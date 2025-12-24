//
//  MainView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: String = "Dashboard"

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Dashboard", systemImage: "house", value: "Dashboard") {
                DashboardView()
            }
            
            Tab("Strategies", systemImage: "chart.pie", value: "Strategies") {
                StrategiesView()
            }
            
            Tab("Settings", systemImage: "gear", value: "Settings") {
                ProfileView()
            }
        }
        .onAppear() {
            let appearance = UITabBarAppearance()
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(.element)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainView()
}
