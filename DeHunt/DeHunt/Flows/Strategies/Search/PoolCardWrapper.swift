//
//  PoolCardWrapper.swift
//  DeHunt
//
//  Created by Rostyslav Mukoida on 25/02/2026.
//
import SwiftUI

struct PoolCardWrapper: View {
    let pool: YieldPool
    @Bindable var viewModel: StrategiesViewModel
    @State private var isPressed = false
    @State private var cancelTask: Task<Void, Never>?
    
    private var isSelected: Bool {
        viewModel.isPoolSelected(pool.pool)
    }
    
    var body: some View {
        StrategiesSearchResultPoolRow(pool: pool, isPressed: $isPressed)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.element.opacity(1), lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.backgroundTertiary.opacity(0.5), lineWidth: 1)
                    }
                }
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isPressed)
            .contentShape(Rectangle())
            .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
            } onPressingChanged: { pressing in
                if pressing {
                    isPressed = true
                    
                    cancelTask = Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        if !Task.isCancelled {
                            isPressed = false
                            viewModel.togglePoolSelection(pool)
                            HapticsEngine.shared.select()
                        }
                    }
                } else {
                    cancelTask?.cancel()
                    isPressed = false
                }
            }
    }
}
