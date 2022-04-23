//
//  Bybit+Account.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation

public enum OrderType: String, Codable, CaseIterable {
    case limit = "Limit"
    case market = "Market"
}

public enum TriggerPriceType: String, Codable, CaseIterable {
    case lastPrice = "LastPrice"
    case indexPrice = "IndexPrice"
    case markPrice = "MarkPrice"
}

public enum TimeInForce: String, Codable, CaseIterable {
    /**
     The order will remain valid until it is fully executed or manually cancelled by the trader. GTC is suitable for traders who are willing to wait for all contracts to be completed at a specified price and can flexibly cancel unconcluded contracts at any time.
     */
    case goodTillCancel = "GoodTillCancel"
    /**
     The order must be immediately executed at the order price or better, otherwise, it will be completely cancelled and partially filled contracts will not be allowed. This execution strategy is more commonly used by scalping traders or day traders looking for short-term market opportunities.
     */
    case fillOrKill = "FillOrKill"
    /**
     The order must be filled immediately at the order limit price or better. If the order cannot be filled immediately, the unfilled contracts will be cancelled. IOC is usually used to avoid large orders being executed at a price that deviates from the ideal price. With this set, the contracts that fail to trade at the specified price will be cancelled.
     */
    case immediateOrCancel = "ImmediateOrCancel"
    case postOnly = "PostOnly"
}

public struct BybitCreateActiveOrder: Codable {
    var side: BybitSide
    var symbol: String
    /// Active order type
    var orderType: OrderType
    /// Order quantity in USD
    var qty: Number
    var timeInForce: TimeInForce
    
    /// Order price
    var price: Number?
    /// For a closing order. It can only reduce your position, not increase it. If the account has insufficient available balance when the closing order is triggered, then other active orders of similar contracts will be cancelled or reduced. It can be used to ensure your stop loss reduces your position regardless of current available margin.
    var closeOnTrigger: Bool = false
    /// Unique user-set order ID. Maximum length of 36 characters
    var orderLinkId: String?
    /// Take profit price, only take effect upon opening the position
    var takeProfit: Number?
    /// Stop loss price, only take effect upon opening the position
    var stopLoss: Number?
    /// Take profit trigger price type, default: LastPrice
    var tpTriggerBy: TriggerPriceType = .lastPrice
    /// Stop loss trigger price type, default: LastPrice
    var slTriggerBy: TriggerPriceType = .lastPrice
    /// True means your position can only reduce in size if this order is triggered
    var reduceOnly: Bool = false
}

public struct BybitActiveOrder: Codable {
    var userId: Number
    var symbol: String
    var side: BybitSide
    var orderType: OrderType
    var qty: Number
    var price: Number?
    var timeInForce: TimeInForce
}

public struct BybitPosition: Codable {
    var id: Number?
    var positionIdx: Number
    var mode: Number
    var userId: Number
    var riskId: Number
    var symbol: String
    var side: BybitSide
    var size: Number
    var positionValue: Number
    var entryPrice: Number
    var liqPrice: Number
    var bustPrice: Number
    var leverage: Number
    var autoAddMargin: Number
    var isIsolated: Bool?
    var positionMargin: Number
    var occClosingFee: Number
    var realisedPnl: Number
    var cumRealisedPnl: Number
    var freeQty: Number
    var tpSlMode: String
    var deleverageIndicator: Number?
    var unrealisedPnl: Number?
    var takeProfit: Number
    var stopLoss: Number
    var trailingStop: Number
}

public struct ClosedProfitAndLossRecords: Codable {
    var id: Number
    var userId: Number
    var orderId: Number
    var symbol: String
    var side: BybitSide
    var qty: Number
    var orderPrice: Number
    var orderType: OrderType
    var execType: String
    var closedSize: Number
    var cumEntryValue: Number
    var avgEntryPrice: Number
    var cumExitValue: Number
    var avgExitPrice: Number
    var closedPnl: Number
    var fillCount: Number
    var leverage: Number
    var createdAt: Number
}

extension BybitClient {
    /// Get wallet balance info.
    public func activeOrder(_ order: BybitCreateActiveOrder) async throws -> BybitPublic<BybitActiveOrder> {
        return try await post("/private/linear/order/create", body: order)
        /**
         , searchParams: [
             "side": order.side.rawValue,
             "symbol": order.symbol,
             "order_type": order.orderType.rawValue,
             "qty": order.qty.asString,
             "time_in_force": order.timeInForce.rawValue,
             "price": order.price?.asString,
             "close_on_trigger": order.closeOnTrigger ? "true" : "false",
             "order_link_id": order.orderLinkId,
             "take_profit": order.takeProfit?.asString,
             "stop_loss": order.stopLoss?.asString,
             "tp_trigger_by": order.tpTriggerBy,
             "sl_trigger_by": order.slTriggerBy,
             "reduce_only": order.reduceOnly ? "true" : "false",
         ]
         */
    }
    
    /// Get my position.
    public func position(symbol: String) async throws -> BybitPublic<[BybitPosition]> {
        return try await get("/private/linear/position/list", searchParams: ["symbol": symbol])
    }
    
    /// Get my position list.
    public func position() async throws -> BybitPublic<[BybitResult<BybitPosition>]> {
        return try await get("/private/linear/position/list")
    }
    
    /// Get my position list.
    public func closedProfitAndLossRecords(symbol: String) async throws -> BybitPublic<BybitPage<[ClosedProfitAndLossRecords]>> {
        return try await get("/private/linear/trade/closed-pnl/list", searchParams: ["symbol": symbol])
    }
}
