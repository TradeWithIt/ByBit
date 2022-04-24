//
//  Bybit+Wallet.swift
//  TradeWithMe
//
//  Created by Szymon on 9/3/2022.
//

import Foundation
import API

public struct BybitCoin: Codable {
    var equity: Number
    var availableBalance: Number
    var usedMargin: Number
    var orderMargin: Number
    var positionMargin: Number
    var occClosingFee: Number
    var occFundingFee: Number
    var walletBalance: Number
    var realisedPnl: Number
    var unrealisedPnl: Number
    var cumRealisedPnl: Number
    var givenCash: Number
    var serviceCash: Number
}

extension BybitClient {
    /// Get wallet balance info.
    public func balance(coin: String? = nil) async throws -> BybitPublic<[String: BybitCoin]> {
        return try await get("/v2/private/wallet/balance", searchParams: ["coin": coin])
    }
}
