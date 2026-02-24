//
//  MarketOverviewCard.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 16/12/2025.
//

import SwiftUI

struct MarketOverviewCard: View {
    let metric: MarketOverviewMetric
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(metric.title)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(spacing: 6) {
                Text(metric.valueText)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text(metric.subtitleText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(metric.changeColor)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 145)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isPressed)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        MarketOverviewCard(
            metric: .tvl(value: 55_300_000, changePercent: 12.5)
        )
        
        MarketOverviewCard(
            metric: .topProtocol(name: "Aave", tvl: 12_500_000, changePercent: 5.2)
        )
        
        MarketOverviewCard(
            metric: .topChain(name: "Ethereum", tvl: 45_000_000, changePercent: -1.5)
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}
