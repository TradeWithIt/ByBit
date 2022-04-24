//
//  Bybit+Wallet.swift
//  TradeWithMe
//
//  Created by Szymon on 9/3/2022.
//

import Foundation
import API

public struct BybitCoin: Codable {
    public var equity: Number
    public var availableBalance: Number
    public var usedMargin: Number
    public var orderMargin: Number
    public var positionMargin: Number
    public var occClosingFee: Number
    public var occFundingFee: Number
    public var walletBalance: Number
    public var realisedPnl: Number
    public var unrealisedPnl: Number
    public var cumRealisedPnl: Number
    public var givenCash: Number
    public var serviceCash: Number
}

extension BybitClient {
    /// Get wallet balance info.
    public func balance(coin: String? = nil) async throws -> BybitPublic<[String: BybitCoin]> {
        return try await get("/v2/private/wallet/balance", searchParams: ["coin": coin])
    }
}
