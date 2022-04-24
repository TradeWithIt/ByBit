# ByBit

Swift API connector for [Bybit's](https://bybit-exchange.github.io/docs/linear/#t-introduction) HTTP and WebSockets APIs.

Mostly implementing USDT Perpetual at this time. Feel free to contiriubte and help build this API.

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/TradeWithIt/ByBit", branch: "main")
]
```

## Usage 

create client

```swift
let env = env = BybitEnvironment.bybitTestnet(key: appKey, secret: appSecret)
let account = Account(name: name, api: env.api, key: appKey, secret: appSecret)
let bybit = try await BybitClient(.api(account.api, key: account.key, secret: account.secret))
```

load klines

```swift
private(set) var bybit: BybitClient?
let interval: BybitDataRefreshInterval = .fiveMin
let now = bybit.environment.currentServerTime + 12,000
let from = 60,000
let klines = try await bybit.kline(symbol: "USDT", interval: interval, from: Int(now - from))
```
