//
//  MarketOverviewCard.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 16/12/2025.
//

import SwiftUI

struct MarketOverviewCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(spacing: 6) {
                Text(value)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.textPositive)
                
                Text(subtitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPositive)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 145)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .scaleEffect(isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isPressed)
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
            title: "Total Market TVL",
            value: "$55.3M", 
            subtitle: "+12.5%"
        )
        
        MarketOverviewCard(
            title: "Active Users", 
            value: "1,234", 
            subtitle: "+156 today"
        )
    }
    .padding()
    .background(Color.backgroundPrimary)
}
