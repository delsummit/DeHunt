//
//  ChainChip.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 06/01/2026.
//

import SwiftUI

struct ChainChip: View {
    let chain: BlockchainChain
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsEngine.shared.lightTap()
            action()
        }) {
            HStack(spacing: 8) {
                AsyncImage(url: chain.trustWalletIconURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                    case .failure, .empty:
                        Image(systemName: chain.iconName)
                            .font(.system(size: 16))
                            .foregroundStyle(isSelected ? .white : chain.color)
                    @unknown default:
                        Image(systemName: chain.iconName)
                            .font(.system(size: 16))
                            .foregroundStyle(isSelected ? .white : chain.color)
                    }
                }
                .frame(width: 20, height: 20)
                
                Text(chain.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .buttonStyle(.borderedProminent)
        .glassEffect(.regular.interactive())
        .tint(isSelected ? .element : .backgroundPrimary)
    }
}
