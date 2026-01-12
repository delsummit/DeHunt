//
//  StrategiesSearchResultPoolRow.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 11/01/2026.
//

import SwiftUI

struct StrategiesSearchResultPoolRow: View {
    let pool: YieldPool
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Text(pool.project)
                    .font(.headline)
                
                Spacer()
                
                chainImage
            }
            
            Divider()
            
            HStack {
                Text("Pool")
                    .fontWeight(.semibold)

                Spacer()

                Text("\(pool.symbol)")
                    .foregroundStyle(.element)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            HStack {
                Text("APY")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(pool.apy, specifier: "%.2f")%")
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            HStack {
                Text("Total Value Locked")
                    .fontWeight(.semibold)

                
                Spacer()
                
                Text("$\(pool.tvlUsd, specifier: "%.0f")")
                    .fontWeight(.semibold)
                    .foregroundStyle(.element)
            }
                .font(.subheadline)
            HStack {
                Spacer()
                
                Button {
                    if let url = URL(string: "https://defillama.com/yields/pool/\(pool.pool)") {
                        openURL(url)
                    }
                } label: {
                    HStack (spacing: 2){
                        Text("Find this pool on DefiLlama")
                            .font(.footnote)
                            .underline()
                        Image(systemName: "arrow.up.forward.app")
                            .font(.caption2)
                    }
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.textPrimary)
            }
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var chainImage: some View {
        HStack(spacing: 6) {
            if let chain = BlockchainChain.allCases.first(where: { $0.matches(apiChainName: pool.chain) }) {
                AsyncImage(url: chain.trustWalletIconURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    case .failure, .empty:
                        Image(systemName: chain.iconName)
                            .font(.system(size: 14))
                            .foregroundStyle(chain.color)
                    @unknown default:
                        Image(systemName: chain.iconName)
                            .font(.system(size: 14))
                            .foregroundStyle(chain.color)
                    }
                }
                .frame(width: 24, height: 24)
                
                Text(pool.chain)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        StrategiesSearchResultView(pools: [
            YieldPool(
                pool: "1",
                chain: "Ethereum",
                project: "Aave",
                symbol: "USDC",
                tvlUsd: 1250000,
                apy: 5.67
            ),
            YieldPool(
                pool: "2",
                chain: "Polygon",
                project: "Uniswap",
                symbol: "ETH-USDT",
                tvlUsd: 3400000,
                apy: 12.34
            ),
            YieldPool(
                pool: "3",
                chain: "Arbitrum",
                project: "Curve",
                symbol: "DAI-USDC-USDT",
                tvlUsd: 8900000,
                apy: 8.92
            )
        ])
    }
}
