//
//  ByBit+Enviroment.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation
import CryptoSwift
import API

extension String {
    public func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

public struct BybitEnvironment: ApiEnvironment {
    public var api: API
    public var key: String
    public var secret: String
    internal var timestamp: TimeInterval? = nil
    internal var clockQueryTime: Date? = nil

    public var currentServerTime: Double {
        let now = (timestamp ?? 0) - (clockQueryTime?.timeIntervalSinceNow ?? 0)
        return now
    }
    
    public static func api(_ api: API, key: String, secret: String) -> Self {
        return BybitEnvironment(api: api, key: key, secret: secret)
    }
    
    public static func bybitTestnet(key: String, secret: String) -> Self {
        let api = API(http: "https://api-testnet.bybit.com", wss: "wss://stream-testnet.bybit.com")
        return BybitEnvironment(api: api, key: key, secret: secret)
    }

    public static func bybitMainnet(key: String, secret: String) -> Self {
        let api = API(http: "https://api.bybit.com", wss: "wss://stream.bybit.com")
        return BybitEnvironment(api: api, key: key, secret: secret)
    }

    public static func bybitMainnet2(key: String, secret: String) -> Self {
        let api = API(http: "https://api.bytick.com", wss: "wss://stream.bytick.com")
        return BybitEnvironment(api: api, key: key, secret: secret)
    }

    public func setQueryParams(_ query: HTTPQueryParams?, api: String) -> HTTPQueryParams? {
        if api.starts(with: "https://") {
            return setHTTPQueryParams(query)
        } else if api.starts(with: "wss://") {
            return setWSSQueryParams(query)
        } else {
            return query
        }
    }
    
    public func setHeaders(request: inout URLRequest) {}
    
    
    internal func setHTTPQueryParams(_ query: HTTPQueryParams?) -> HTTPQueryParams? {
        var searchParams = query ?? HTTPQueryParams()
        searchParams["api_key"] = key
        searchParams["recv_window"] = "5000"
        if let _ = timestamp {
            searchParams["timestamp"] = String(Int(currentServerTime * 1000))
        }
        if let sign = sign(key: secret, query: searchParams) {
            searchParams["sign"] = sign
        }
        return searchParams.isEmpty ? nil : searchParams
    }
    
    internal func setWSSQueryParams(_ query: HTTPQueryParams?) -> HTTPQueryParams? {
        var searchParams = query ?? HTTPQueryParams()

        let expires = String(format: "%.0f", Date().addingTimeInterval(1000).timeIntervalSince1970 * 1000)
        searchParams["expires"] = expires
        searchParams["api_key"] = key
        searchParams["signature"] = sign(key: secret, expires: expires)
        return searchParams.isEmpty ? nil : searchParams
    }

    internal func sign(key: String, expires: String) -> String {
        let inputData = Data("GET/realtime\(expires)".utf8)
        let hash = try? HMAC(key: key, variant: .sha2(.sha256)).authenticate(Array(inputData))
        return hash?.toHexString() ?? ""
    }

    internal func sign(key: String, query: HTTPQueryParams) -> String? {
        let sorted = query.sorted { $0.0 < $1.0 }
        let inputString = sorted.reduce(into: "") { partialResult, dic in
            guard let value = dic.value else { return }
            if partialResult.isEmpty {
                partialResult = "\(dic.key)=\(value)"
            } else {
                partialResult.append("&\(dic.key)=\(value)")
            }
        }
        let inputData = Data(inputString.utf8)
        let hash = try? HMAC(key: key, variant: .sha2(.sha256)).authenticate(Array(inputData))
        return hash?.toHexString() ?? ""
    }
}
