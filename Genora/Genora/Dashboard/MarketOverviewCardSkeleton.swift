//
//  MarketOverviewCardSkeleton.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 18/12/2025.
//

import SwiftUI

struct MarketOverviewCardSkeleton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0))
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
            
            VStack(spacing: 12) {
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 100, height: 16)
                
                Spacer()
                
                VStack(spacing: 6) {
                    Capsule()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 80, height: 26)
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 60, height: 14)
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 145)
        .overlay {
            SkeletonView(
                RoundedRectangle(cornerRadius: 16),
                .white.opacity(0)
            )
            .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack {
            MarketOverviewCardSkeleton()
            MarketOverviewCardSkeleton()
        }
        
        HStack {
            MarketOverviewCardSkeleton()
            MarketOverviewCardSkeleton()
        }
    }
    .padding()
    .background(Color.backgroundPrimary)
}
