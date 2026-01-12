//
//  ChainIconStackView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 06/01/2026.
//

import SwiftUI

struct ChainIconStackView: View {
    let chains: [BlockchainChain]
    let maxVisible: Int
    let iconSize: CGFloat
    let overlapOffset: CGFloat
    
    init(
        chains: [BlockchainChain],
        maxVisible: Int = 7,
        iconSize: CGFloat = 32,
        overlapOffset: CGFloat = -8
    ) {
        self.chains = chains
        self.maxVisible = maxVisible
        self.iconSize = iconSize
        self.overlapOffset = overlapOffset
    }
    
    private var sortedChains: [BlockchainChain] {
        chains.sorted { $0.rawValue < $1.rawValue }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(sortedChains.prefix(maxVisible).enumerated().map { $0 }, id: \.element.id) { index, chain in
                ChainIcon(chain: chain, size: iconSize)
                    .offset(x: CGFloat(index) * overlapOffset)
                    .zIndex(Double(chains.count - index))
            }
            
            if chains.count > maxVisible {
                OverflowBadge(count: chains.count - maxVisible, size: iconSize)
                    .offset(x: CGFloat(maxVisible) * overlapOffset)
            }
        }
        .padding(.leading, abs(overlapOffset))
    }
}

private struct ChainIcon: View {
    let chain: BlockchainChain
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: chain.trustWalletIconURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure, .empty:
                Image(systemName: chain.iconName)
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(chain.color)
            @unknown default:
                Image(systemName: chain.iconName)
                    .font(.system(size: size * 0.5))
                    .foregroundStyle(chain.color)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .background(
            Circle()
                .fill(Color(.systemBackground))
        )
    }
}

private struct OverflowBadge: View {
    let count: Int
    let size: CGFloat
    
    var body: some View {
        Text("+\(count)")
            .font(.system(size: size * 0.35, weight: .semibold))
            .foregroundStyle(.textPrimary)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(Color.backgroundTertiary)
            )
    }
}
