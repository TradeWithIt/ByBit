//
//  Bybit+Wallet.swift
//  TradeWithMe
//
//  Created by Szymon on 9/3/2022.
//

import Foundation
import API

public struct BybitCoin: Codable {
    public init(equity: Number, availableBalance: Number, usedMargin: Number, orderMargin: Number, positionMargin: Number, occClosingFee: Number, occFundingFee: Number, walletBalance: Number, realisedPnl: Number, unrealisedPnl: Number, cumRealisedPnl: Number, givenCash: Number, serviceCash: Number) {
        self.equity = equity
        self.availableBalance = availableBalance
        self.usedMargin = usedMargin
        self.orderMargin = orderMargin
        self.positionMargin = positionMargin
        self.occClosingFee = occClosingFee
        self.occFundingFee = occFundingFee
        self.walletBalance = walletBalance
        self.realisedPnl = realisedPnl
        self.unrealisedPnl = unrealisedPnl
        self.cumRealisedPnl = cumRealisedPnl
        self.givenCash = givenCash
        self.serviceCash = serviceCash
    }
    
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
