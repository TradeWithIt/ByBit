//
//  Bybit+Websocket.swift
//  TradeWithMe
//
//  Created by Szymon on 5/3/2022.
//

import Foundation

public struct BybitWssMessage: Encodable {
    var op: String
    var args: [String]
}

public struct BybitWssResponse<T: Decodable>: Decodable {
    let topic: String
    let data: T
}

extension BybitWssResponse where T == [BybitKlineV2] {
    var interval: BybitDataRefreshInterval? {
        let array = topic.split(separator: ".")
        guard array.count > 1 else { return nil }
        return BybitDataRefreshInterval(rawValue: String(array[array.count - 2]))
    }
    
    var symbol: String? {
        let array = topic.split(separator: ".")
        guard array.count > 0 else { return nil }
        return array.last.map(String.init)
    }
}

public struct BybitKlineV2: Decodable, Hashable {
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
    let update: [T]
}

public struct BybitSymbolInformationDelta: Codable {
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
    let walletBalance: Number
    /// Available balance = wallet balance - used margin
    let availableBalance: Number
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
