//
//  MainView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "house") {
                DashboardView()
            }
            
            Tab("Strategies", systemImage: "chart.pie") {
                StrategiesView()
            }
            
            Tab("Pools", systemImage: "cube") {
                PoolsView()
            }
            
            Tab("Profile", systemImage: "person") {
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
