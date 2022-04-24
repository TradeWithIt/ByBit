//
//  Bybit+MarketData.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation
import API

public enum BybitSide: String, Codable, CaseIterable {
    case none = "None"
    case buy = "Buy"
    case sell = "Sell"
}

public enum BybitTickDirection: String, Codable, CaseIterable {
    case priceRise = "PlusTick"
    case priceRiseZero = "ZeroPlusTick"
    case priceDrop = "MinusTick"
    case priceDropZero = "ZeroMinusTick"
    
    public var isPositive: Bool {
        switch self {
        case .priceRise, .priceRiseZero:
            return true
        case .priceDrop, .priceDropZero:
            return false
        }
    }
}

public enum BybitDataRefreshInterval: String, Codable, CaseIterable, Equatable {
    public static var intervals: [BybitDataRefreshInterval] {
        [.oneMin, .fiveMin, .fifteenMin, .thirtyMin, .sixtyMin, .fourHour, .oneDay]
    }

    case oneMin = "1"
    case threeMin = "3"
    case fiveMin = "5"
    case fifteenMin = "15"
    case thirtyMin = "30"
    case sixtyMin = "60"
    case twoHour = "120"
    case fourHour = "240"
    case sixHour = "360"
    case twelveHour = "720"
    case oneDay = "D"
    case oneMonth = "M"
    case oneWeek = "W"
    
    public var leftInterval: BybitDataRefreshInterval {
        guard let i = BybitDataRefreshInterval.intervals.firstIndex(of: self), (i - 1) >= 0 else { return .oneMin }
        return BybitDataRefreshInterval.intervals[i - 1]
    }
    
    public var rightInterval: BybitDataRefreshInterval {
        guard let i = BybitDataRefreshInterval.intervals.firstIndex(of: self), (i + 1) < BybitDataRefreshInterval.intervals.count else { return .oneDay }
        return BybitDataRefreshInterval.intervals[i + 1]
    }
    
}

public enum BybitPeriod: String, Codable, CaseIterable {
    case fiveMin = "5min"
    case fifteenMin = "15min"
    case thirtyMin = "30min"
    case sixtyMin = "1h"
    case fourHour = "4h"
    case oneDay = "1d"
}

public struct BybitOrderBook: Codable {
    public init(symbol: String, price: String, side: BybitSide, size: Number) {
        self.symbol = symbol
        self.price = price
        self.side = side
        self.size = size
    }
    
    public let symbol: String
    public let price: String
    public let side: BybitSide
    public let size: Number
}

public struct BybitKline: Codable, Hashable {
    public init(symbol: String, interval: BybitDataRefreshInterval, openTime: UInt64, open: Number, high: Number, low: Number, close: Number, volume: Number, turnover: Number) {
        self.symbol = symbol
        self.interval = interval
        self.openTime = openTime
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.turnover = turnover
    }
    
    public let symbol: String
    public let interval: BybitDataRefreshInterval
    public let openTime: UInt64
    
    public let open: Number
    public let high: Number
    public let low: Number
    public let close: Number
    public let volume: Number
    public let turnover: Number
    
}

public struct BybitKlineMarkPrice: Codable {
    public init(symbol: String, period: BybitPeriod, startAt: Number, open: Number, high: Number, low: Number, close: Number) {
        self.symbol = symbol
        self.period = period
        self.startAt = startAt
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
    
    public let symbol: String
    public let period: BybitPeriod
    public let startAt: Number
    
    public let open: Number
    public let high: Number
    public let low: Number
    public let close: Number
}

public struct BybitKlineIndexPrice: Codable {
    public init(symbol: String, period: BybitPeriod, openTime: UInt64, open: Number, high: Number, low: Number, close: Number) {
        self.symbol = symbol
        self.period = period
        self.openTime = openTime
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
    
    public let symbol: String
    public let period: BybitPeriod
    public let openTime: UInt64
    
    public let open: Number
    public let high: Number
    public let low: Number
    public let close: Number
}

public struct BybitSymbolInformation: Codable, Equatable {
    public init(symbol: String, nextFundingTime: Date?, lastTickDirection: BybitTickDirection, bidPrice: Number, askPrice: Number, lastPrice: Number, prevPrice24H: Number, price24HPcnt: Number, highPrice24H: Number, lowPrice24H: Number, prevPrice1H: Number, price1HPcnt: Number, markPrice: Number, indexPrice: Number, openInterest: Number, openValue: Number, totalTurnover: Number, turnover24H: Number, totalVolume: Number, volume24H: Number, fundingRate: Number, predictedFundingRate: Number, countdownHour: Number, deliveryFeeRate: Number, predictedDeliveryPrice: Number, deliveryTime: Number) {
        self.symbol = symbol
        self.nextFundingTime = nextFundingTime
        self.lastTickDirection = lastTickDirection
        self.bidPrice = bidPrice
        self.askPrice = askPrice
        self.lastPrice = lastPrice
        self.prevPrice24H = prevPrice24H
        self.price24HPcnt = price24HPcnt
        self.highPrice24H = highPrice24H
        self.lowPrice24H = lowPrice24H
        self.prevPrice1H = prevPrice1H
        self.price1HPcnt = price1HPcnt
        self.markPrice = markPrice
        self.indexPrice = indexPrice
        self.openInterest = openInterest
        self.openValue = openValue
        self.totalTurnover = totalTurnover
        self.turnover24H = turnover24H
        self.totalVolume = totalVolume
        self.volume24H = volume24H
        self.fundingRate = fundingRate
        self.predictedFundingRate = predictedFundingRate
        self.countdownHour = countdownHour
        self.deliveryFeeRate = deliveryFeeRate
        self.predictedDeliveryPrice = predictedDeliveryPrice
        self.deliveryTime = deliveryTime
    }
    
    public let symbol: String
    public let nextFundingTime: Date?
    public var lastTickDirection: BybitTickDirection
    public var bidPrice: Number
    public var askPrice: Number
    public var lastPrice: Number
    public var prevPrice24H: Number
    public var price24HPcnt: Number
    public var highPrice24H: Number
    public var lowPrice24H: Number
    public var prevPrice1H: Number
    public var price1HPcnt: Number
    public var markPrice: Number
    public var indexPrice: Number
    public var openInterest: Number
    public var openValue: Number
    public var totalTurnover: Number
    public var turnover24H: Number
    public var totalVolume: Number
    public var volume24H: Number
    public var fundingRate: Number
    public var predictedFundingRate: Number
    public var countdownHour: Number
    public var deliveryFeeRate: Number
    public var predictedDeliveryPrice: Number
    public var deliveryTime: Number
}

public struct BybitTradingRecords: Codable {
    public init(id: Number, symbol: String, price: Number, qty: Number, side: BybitSide, time: Date) {
        self.id = id
        self.symbol = symbol
        self.price = price
        self.qty = qty
        self.side = side
        self.time = time
    }
    
    public let id: Number
    public let symbol: String
    public let price: Number
    public let qty: Number
    public let side: BybitSide
    public let time: Date
}

public enum BybitContractStatus: String, Codable, CaseIterable {
    case trading = "Trading"
    case settling = "Settling"
    case closed = "Closed"
}

public struct LeverageFilter: Codable {
    public init(minLeverage: Number, maxLeverage: Number, leverageStep: Number) {
        self.minLeverage = minLeverage
        self.maxLeverage = maxLeverage
        self.leverageStep = leverageStep
    }
    
    public let minLeverage: Number
    public let maxLeverage: Number
    public let leverageStep: Number
}

public struct PriceFilter: Codable {
    public init(minPrice: Number, maxPrice: Number, tickSize: Number) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.tickSize = tickSize
    }
    
    public let minPrice: Number
    public let maxPrice: Number
    public let tickSize: Number
}

public struct LotSizeFilter: Codable {
    public init(maxTradingQty: Number, minTradingQty: Number, qtyStep: Number) {
        self.maxTradingQty = maxTradingQty
        self.minTradingQty = minTradingQty
        self.qtyStep = qtyStep
    }
    
    public let maxTradingQty: Number
    public let minTradingQty: Number
    public let qtyStep: Number
}

public struct BybitQuerySymbol: Codable {
    public init(name: String, alias: String, status: BybitContractStatus, baseCurrency: String, quoteCurrency: String, priceScale: Number, takerFee: Number, makerFee: Number, leverageFilter: LeverageFilter, priceFilter: PriceFilter, lotSizeFilter: LotSizeFilter) {
        self.name = name
        self.alias = alias
        self.status = status
        self.baseCurrency = baseCurrency
        self.quoteCurrency = quoteCurrency
        self.priceScale = priceScale
        self.takerFee = takerFee
        self.makerFee = makerFee
        self.leverageFilter = leverageFilter
        self.priceFilter = priceFilter
        self.lotSizeFilter = lotSizeFilter
    }
    
    public let name: String
    public let alias: String
    public let status: BybitContractStatus
    public let baseCurrency: String
    public let quoteCurrency: String
    
    public let priceScale: Number
    
    public let takerFee: Number
    public let makerFee: Number
    
    public let leverageFilter: LeverageFilter
    public let priceFilter: PriceFilter
    public var lotSizeFilter: LotSizeFilter
}

public struct BybitOpenInterest: Codable {
    public init(symbol: String, side: BybitSide, timestamp: Number, value: Number) {
        self.symbol = symbol
        self.side = side
        self.timestamp = timestamp
        self.value = value
    }
    
    public let symbol: String
    public let side: BybitSide
    public let timestamp: Number
    public let value: Number
}

public struct BybitBigDeal: Codable {
    public init(symbol: String, timestamp: Number, openInterest: Number) {
        self.symbol = symbol
        self.timestamp = timestamp
        self.openInterest = openInterest
    }
    
    public let symbol: String
    public let timestamp: Number
    public let openInterest: Number
}

public struct BybitLongShortRatio: Codable {
    public init(symbol: String, buyRatio: Double, sellRatio: Double, timestamp: Number) {
        self.symbol = symbol
        self.buyRatio = buyRatio
        self.sellRatio = sellRatio
        self.timestamp = timestamp
    }
    
    public let symbol: String
    public let buyRatio: Double
    public let sellRatio: Double
    public let timestamp: Number
}

extension BybitClient {
    /// Get the orderbook. Each side has a depth of 50.
    /// - Parameter symbol: Symbol
    /// - Returns: BybitOrderBook
    public func orderBook(symbol: String) async throws -> BybitPublic<BybitOrderBook> {
        return try await get("/v2/public/orderBook/L2", searchParams: ["symbol": symbol])
    }
    
    /// Get kline.
    /// - Parameters:
    ///   - symbol: Symbol
    ///   - interval: Data refresh interval. Enum : 1 3 5 15 30 60 120 240 360 720 "D" "M" "W"
    ///   - from: From timestamp in seconds
    ///   - limit: Limit for data size per page, max size is 200. Default as showing 200 pieces of data per page
    /// - Returns: Kline list.
    public func kline(symbol: String, interval: BybitDataRefreshInterval, from: Int, limit: Int? = nil) async throws -> BybitPublic<[BybitKline]> {
        return try await get("/public/linear/kline", searchParams: [
            "symbol": symbol,
            "interval": interval.rawValue,
            "from": String(from),
            "limit": limit.map(String.init)
        ])
    }
    
    public func klineMarkPrice(symbol: String, interval: BybitDataRefreshInterval, from: Int, limit: Int? = nil) async throws -> BybitPublic<[BybitKline]> {
        return try await get("/public/linear/mark-price-kline", searchParams: [
            "symbol": symbol,
            "interval": interval.rawValue,
            "from": String(from),
            "limit": limit.map(String.init)
        ])
    }
    
    public func klineIndexPrice(symbol: String, interval: BybitDataRefreshInterval, from: Int, limit: Int? = nil) async throws -> BybitPublic<[BybitKline]> {
        return try await get("/public/linear/index-price-kline", searchParams: [
            "symbol": symbol,
            "interval": interval.rawValue,
            "from": String(from),
            "limit": limit.map(String.init)
        ])
    }
    
    /// Get the latest information for symbol.
    /// - Parameter symbol: Symbol
    /// - Returns: Latest Information for Symbol
    public func symbolInformation(symbol: String?) async throws -> BybitPublic<[BybitSymbolInformation]> {
        return try await get("/v2/public/tickers", searchParams: ["symbol": symbol])
    }
    
    /// Get recent trades. You can find a complete history of trades on Bybit official site.
    /// - Parameters:
    ///   - symbol: Symbol
    ///   - limit: Limit for data size, max size is 1000. Default size is 500
    /// - Returns: recent trades
    public func tradingRecords(symbol: String, limit: Int? = nil) async throws -> BybitPublic<[BybitTradingRecords]> {
        return try await get("/public/linear/recent-trading-records", searchParams: ["symbol": symbol, "limit": limit.map(String.init)])
    }
    
    /// Get symbol info.
    public func querySymbol() async throws -> BybitPublic<[BybitQuerySymbol]> {
        return try await get("/v2/public/symbols")
    }

    
    /// Gets the total amount of unsettled contracts. In other words, the total number of contracts held in open positions.
    /// - Parameters:
    ///   - symbol: Symbol
    ///   - period: Data recording period. 5min, 15min, 30min, 1h, 4h, 1d
    ///   - limit: Limit for data size per page, max size is 200. Default as showing 50 pieces of data per page
    public func openInterest(symbol: String, period: BybitPeriod, limit: Int? = nil) async throws -> BybitPublic<BybitOpenInterest> {
        return try await get("/v2/public/open-interest", searchParams: [
            "symbol": symbol,
            "period": period.rawValue,
            "limit": limit.map(String.init)
        ])
    }
    
    /// Obtain filled orders worth more than 500,000 USD within the last 24h. This endpoint may return orders which are over the maximum order qty for the symbol you call. For instance, the maximum order qty for BTCUSD is 1 million contracts, but in the event of the liquidation of a position larger than 1 million this endpoint returns this "impossible" order size.
    /// - Parameters:
    ///   - symbol: Symbol
    ///   - limit: Limit for data size per page, max size is 200. Default as showing 50 pieces of data per page
    public func latestBigDeal(symbol: String, limit: Int? = nil) async throws -> BybitPublic<BybitBigDeal> {
        return try await get("/v2/public/big-deal", searchParams: [
            "symbol": symbol,
            "limit": limit.map(String.init)
        ])
    }
    
    /// Gets the Bybit user accounts' long-short ratio.
    /// - Parameters:
    ///   - symbol: Symbol
    ///   - period: Data recording period. 5min, 15min, 30min, 1h, 4h, 1d
    ///   - limit: Limit for data size per page, max size is 200. Default as showing 50 pieces of data per page
    public func longShortRatio(symbol: String, period: BybitPeriod, limit: Int? = nil) async throws -> BybitPublic<[BybitLongShortRatio]> {
        return try await get("/v2/public/account-ratio", searchParams: [
            "symbol": symbol,
            "period": period.rawValue,
            "limit": limit.map(String.init)
        ])
    }
}
