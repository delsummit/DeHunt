//
//  DeHuntApp.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 14/12/2025.
//

import SwiftUI
import SwiftData

@main
struct DeHuntApp: App {
    
    init() {
        HapticsEngine.shared.prepareHaptics()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [YieldPool.self])
    }
}
