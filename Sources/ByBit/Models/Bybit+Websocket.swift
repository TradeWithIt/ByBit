//
//  Bybit+Websocket.swift
//  TradeWithMe
//
//  Created by Szymon on 5/3/2022.
//

import Foundation
import API

public struct BybitWssMessage: Encodable {
    public init(op: String, args: [String]) {
        self.op = op
        self.args = args
    }
    
    public var op: String
    public var args: [String]
}

public struct BybitWssResponse<T: Decodable>: Decodable {
    public init(topic: String, data: T) {
        self.topic = topic
        self.data = data
    }
    
    public let topic: String
    public let data: T
}

extension BybitWssResponse where T == [BybitKlineV2] {
    public var interval: BybitDataRefreshInterval? {
        let array = topic.split(separator: ".")
        guard array.count > 1 else { return nil }
        return BybitDataRefreshInterval(rawValue: String(array[array.count - 2]))
    }
    
    public var symbol: String? {
        let array = topic.split(separator: ".")
        guard array.count > 0 else { return nil }
        return array.last.map(String.init)
    }
}

public struct BybitKlineV2: Decodable, Hashable {
    public init(start: UInt64, end: UInt64, open: Number, high: Number, low: Number, close: Number, volume: Number, turnover: Number) {
        self.start = start
        self.end = end
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.turnover = turnover
    }
    
    public let start: UInt64
    public let end: UInt64
    
    public let open: Number
    public let high: Number
    public let low: Number
    public let close: Number
    public let volume: Number
    public let turnover: Number
    
}

public struct BybitDelta<T: Decodable>: Decodable {
    public init(update: [T]) {
        self.update = update
    }
    
    public let update: [T]
}

public struct BybitSymbolInformationDelta: Codable {
    public init(symbol: String, lastPrice: Number?, indexPrice: Number?, markPrice: Number?, openValueE8: Number?, prevPrice24H: Number?, price24HPcnt: Number?, volume24H: Number?, turnover24HE8: Number?, price24HPcntE6: Number?, highPrice24HE4: Number?, lowPrice24HE4: Number?, lastTickDirection: BybitTickDirection?) {
        self.symbol = symbol
        self.lastPrice = lastPrice
        self.indexPrice = indexPrice
        self.markPrice = markPrice
        self.openValueE8 = openValueE8
        self.prevPrice24H = prevPrice24H
        self.price24HPcnt = price24HPcnt
        self.volume24H = volume24H
        self.turnover24HE8 = turnover24HE8
        self.price24HPcntE6 = price24HPcntE6
        self.highPrice24HE4 = highPrice24HE4
        self.lowPrice24HE4 = lowPrice24HE4
        self.lastTickDirection = lastTickDirection
    }
    
    public let symbol: String
    public let lastPrice: Number?
    public let indexPrice: Number?
    public let markPrice: Number?
    public let openValueE8: Number?
    public let prevPrice24H: Number?
    public let price24HPcnt: Number?
    public let volume24H: Number?
    public let turnover24HE8: Number?
    public let price24HPcntE6: Number?
    public let highPrice24HE4: Number?
    public let lowPrice24HE4: Number?
    public let lastTickDirection: BybitTickDirection?
}

public struct BybitWallet: Decodable, Equatable {
    public init(walletBalance: Number, availableBalance: Number) {
        self.walletBalance = walletBalance
        self.availableBalance = availableBalance
    }
    
    public let walletBalance: Number
    /// Available balance = wallet balance - used margin
    public let availableBalance: Number
}

extension BybitClient {
    public func publicWebsocketRequest(searchParams: HTTPQueryParams? = nil) async throws -> URLRequest {
        try await websocketRequest(path: "/realtime_public", searchParams: searchParams)
    }
    public func privateWebsocketRequest(searchParams: HTTPQueryParams? = nil) async throws -> URLRequest {
        try await websocketRequest(path: "/realtime_private", searchParams: searchParams)
    }
    /// WebSocket data, public topic. klineV2
    public static func auth(apiKey: String, expires: String, signature: String) -> BybitWssMessage {
        BybitWssMessage(op: "auth", args: [apiKey, expires, signature])
    }

    /// WebSocket data, public topic. klineV2
    public static func subscribeKline(symbol: String, interval: BybitDataRefreshInterval) -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: [
            "candle.\(interval.rawValue).\(symbol)"
        ])
    }

    public static func unsubscribeKline(symbol: String, interval: BybitDataRefreshInterval) -> BybitWssMessage {
        BybitWssMessage(op: "unsubscribe", args: [
            "candle.\(interval.rawValue).\(symbol)"
        ])
    }
    
    /// Get latest information for symbol.
    public static func subscribeInformation(symbol: String) -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: [
            "instrument_info.100ms.\(symbol)"
        ])
    }

    public static func unsubscribeInformation(symbol: String) -> BybitWssMessage {
        BybitWssMessage(op: "unsubscribe", args: [
            "instrument_info.100ms.\(symbol)"
        ])
    }
    
    /// Wallet balance
    public static func subscribePosition() -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: ["position"])
    }
    
    /// Wallet balance
    public static func subscribeExecution() -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: ["execution"])
    }
    
    /// Wallet balance
    public static func subscribeOrder() -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: ["order"])
    }
    
    /// Wallet balance
    public static func subscribeStopOrder() -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: ["stop_order"])
    }
    
    /// Wallet balance
    public static func subscribeWallet() -> BybitWssMessage {
        BybitWssMessage(op: "subscribe", args: ["wallet"])
    }
}
