# DeHunt

**DeFi Yield Finding App for iOS**

DeHunt is useful for Crypto Pool hunters/farmers. Built with SwiftUI and using latest iOS-dev technologies. That is the reason why minimal iOS deployment version is 26.0. DeHunt Networking is based on DefiLlama API, so I want to express my gratitude for providing a lot of useful data for free.

![iOS](https://img.shields.io/badge/iOS-26.0+-blue?logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange?logo=swift)

---

## Screenshots

| Dashboard | Strategies | Yields |
|:---------:|:----------:|:------:|
| <img src="Screens/dashboard.png" width="300"> | <img src="Screens/strategy.png" width="300"> | <img src="Screens/yields.png" width="300"> |

---

## Features

### Dashboard
- **Market Overview** - Total DeFi TVL, top protocols, top chains with 24h changes
- **Interactive TVL Chart** - 14-day historical data with touch selection and haptic feedback
- **Real-time Data** - Fetched from DeFi Llama API

### Strategies
- **Yield Pool Search** - Find pools across 20 popular chains
- **Investment Amount Input** - Calculate your profits easily, based on Pool APY and your investment amount
- **Advanced Filters:**
  - Minimum APY slider
  - Minimum TVL (optional)
  - Multi-chain selection (Ethereum, Arbitrum, Base, Solana, etc.)

### Search Results
- **Sortable Results** - By APY or TVL (ascending/descending)
- **Pool Details** - Project, chain, symbol, APY, TVL
- **Direct Links** - Open pool on DeFi Llama

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| **UI Framework** | SwiftUI |
| **Architecture** | MVVM + @Observable |
| **Networking** | URLSession + async/await |
| **Charts** | Swift Charts |
| **Haptics** | CoreHaptics |
| **Effects** | GlassEffect (iOS 26) |
| **API** | [DeFi Llama](https://api-docs.defillama.com/) |

---

## Key Implementation Details

### Modern Concurrency
```swift
// Parallel data loading with TaskGroup
func loadDashboardData() async {
    await withTaskGroup(of: Void.self) { group in
         group.addTask {
                await self.loadMetrics()
            }
            
            group.addTask {
                await self.loadHistoricalTVL()
            }
    }
}
```

### Protocol-Oriented Networking
```swift
protocol DeFiAPIClientProtocol {
    func fetchProtocols() async throws -> [ProtocolsTVL]
    func fetchHistoricalTVL() async throws -> [HistoricalTVL]
    func fetchYieldPools() async throws -> [YieldPool]
}
```

### Dependency Injection
```swift
final class DashboardViewModel {
    private let apiClient: DeFiAPIClientProtocol
    
    init(apiClient: DeFiAPIClientProtocol = DeFiAPIClient()) {
        self.apiClient = apiClient
    }
}
```

### Skeleton Loading States
```swift
if viewModel.isLoadingMetrics {
    MarketOverviewCardSkeleton()
} else {
    MarketOverviewCard(metric: metric)
}
```

---

## Installation

### Requirements
- Xcode 26.0+
- iOS 26.0+
- Swift 5.0+

```bash
git clone https://github.com/delsummit/DeHunt.git
cd dehunt
open DeHunt.xcodeproj
```
---

## API

DeHunt uses the free [DeFi Llama API]([https://defillama.com/docs/api](https://api-docs.defillama.com/)):

| Endpoint | Contains |
|----------|---------|
| `/protocols` | List of all DeFi protocols with their TVL |
| `/v2/historicalChainTvl` | Historical TVL data |
| `yields.llama.fi/pools` | Yield pool data (TVL, APY, pool hash etc) |

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Author

**Rostyslav Mukoida**

- GitHub: [@delsummit](https://github.com/delsummit)
- LinkedIn: [Rostyslav Mukoida](https://linkedin.com/in/mukoidar)

---

<p align="center">
  <b>Powered by</b><br>
  <img src="https://defillama.com/defillama-press-kit/defi/PNG/defillama-light-neutral.png" width="150" alt="DeFi Llama">
</p>
