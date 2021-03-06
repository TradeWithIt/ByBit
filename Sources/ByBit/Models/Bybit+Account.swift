//
//  Bybit+Account.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation
import API

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
    public init(side: BybitSide, symbol: String, orderType: OrderType, qty: Number, timeInForce: TimeInForce, price: Number? = nil, closeOnTrigger: Bool = false, orderLinkId: String? = nil, takeProfit: Number? = nil, stopLoss: Number? = nil, tpTriggerBy: TriggerPriceType = .lastPrice, slTriggerBy: TriggerPriceType = .lastPrice, reduceOnly: Bool = false) {
        self.side = side
        self.symbol = symbol
        self.orderType = orderType
        self.qty = qty
        self.timeInForce = timeInForce
        self.price = price
        self.closeOnTrigger = closeOnTrigger
        self.orderLinkId = orderLinkId
        self.takeProfit = takeProfit
        self.stopLoss = stopLoss
        self.tpTriggerBy = tpTriggerBy
        self.slTriggerBy = slTriggerBy
        self.reduceOnly = reduceOnly
    }
    
    public var side: BybitSide
    public var symbol: String
    /// Active order type
    public var orderType: OrderType
    /// Order quantity in USD
    public var qty: Number
    public var timeInForce: TimeInForce
    
    /// Order price
    public var price: Number?
    /// For a closing order. It can only reduce your position, not increase it. If the account has insufficient available balance when the closing order is triggered, then other active orders of similar contracts will be cancelled or reduced. It can be used to ensure your stop loss reduces your position regardless of current available margin.
    public var closeOnTrigger: Bool = false
    /// Unique user-set order ID. Maximum length of 36 characters
    public var orderLinkId: String?
    /// Take profit price, only take effect upon opening the position
    public var takeProfit: Number?
    /// Stop loss price, only take effect upon opening the position
    public var stopLoss: Number?
    /// Take profit trigger price type, default: LastPrice
    public var tpTriggerBy: TriggerPriceType = .lastPrice
    /// Stop loss trigger price type, default: LastPrice
    public var slTriggerBy: TriggerPriceType = .lastPrice
    /// True means your position can only reduce in size if this order is triggered
    public var reduceOnly: Bool = false
}

public struct BybitActiveOrder: Codable {
    public init(userId: Number, symbol: String, side: BybitSide, orderType: OrderType, qty: Number, price: Number? = nil, timeInForce: TimeInForce) {
        self.userId = userId
        self.symbol = symbol
        self.side = side
        self.orderType = orderType
        self.qty = qty
        self.price = price
        self.timeInForce = timeInForce
    }
    
    public var userId: Number
    public var symbol: String
    public var side: BybitSide
    public var orderType: OrderType
    public var qty: Number
    public var price: Number?
    public var timeInForce: TimeInForce
}

public struct BybitPosition: Codable {
    public init(id: Number? = nil, positionIdx: Number, mode: Number, userId: Number, riskId: Number, symbol: String, side: BybitSide, size: Number, positionValue: Number, entryPrice: Number, liqPrice: Number, bustPrice: Number, leverage: Number, autoAddMargin: Number, isIsolated: Bool? = nil, positionMargin: Number, occClosingFee: Number, realisedPnl: Number, cumRealisedPnl: Number, freeQty: Number, tpSlMode: String, deleverageIndicator: Number? = nil, unrealisedPnl: Number? = nil, takeProfit: Number, stopLoss: Number, trailingStop: Number) {
        self.id = id
        self.positionIdx = positionIdx
        self.mode = mode
        self.userId = userId
        self.riskId = riskId
        self.symbol = symbol
        self.side = side
        self.size = size
        self.positionValue = positionValue
        self.entryPrice = entryPrice
        self.liqPrice = liqPrice
        self.bustPrice = bustPrice
        self.leverage = leverage
        self.autoAddMargin = autoAddMargin
        self.isIsolated = isIsolated
        self.positionMargin = positionMargin
        self.occClosingFee = occClosingFee
        self.realisedPnl = realisedPnl
        self.cumRealisedPnl = cumRealisedPnl
        self.freeQty = freeQty
        self.tpSlMode = tpSlMode
        self.deleverageIndicator = deleverageIndicator
        self.unrealisedPnl = unrealisedPnl
        self.takeProfit = takeProfit
        self.stopLoss = stopLoss
        self.trailingStop = trailingStop
    }
    
    public var id: Number?
    public var positionIdx: Number
    public var mode: Number
    public var userId: Number
    public var riskId: Number
    public var symbol: String
    public var side: BybitSide
    public var size: Number
    public var positionValue: Number
    public var entryPrice: Number
    public var liqPrice: Number
    public var bustPrice: Number
    public var leverage: Number
    public var autoAddMargin: Number
    public var isIsolated: Bool?
    public var positionMargin: Number
    public var occClosingFee: Number
    public var realisedPnl: Number
    public var cumRealisedPnl: Number
    public var freeQty: Number
    public var tpSlMode: String
    public var deleverageIndicator: Number?
    public var unrealisedPnl: Number?
    public var takeProfit: Number
    public var stopLoss: Number
    public var trailingStop: Number
}

public struct ClosedProfitAndLossRecords: Codable {
    public init(id: Number, userId: Number, orderId: Number, symbol: String, side: BybitSide, qty: Number, orderPrice: Number, orderType: OrderType, execType: String, closedSize: Number, cumEntryValue: Number, avgEntryPrice: Number, cumExitValue: Number, avgExitPrice: Number, closedPnl: Number, fillCount: Number, leverage: Number, createdAt: Number) {
        self.id = id
        self.userId = userId
        self.orderId = orderId
        self.symbol = symbol
        self.side = side
        self.qty = qty
        self.orderPrice = orderPrice
        self.orderType = orderType
        self.execType = execType
        self.closedSize = closedSize
        self.cumEntryValue = cumEntryValue
        self.avgEntryPrice = avgEntryPrice
        self.cumExitValue = cumExitValue
        self.avgExitPrice = avgExitPrice
        self.closedPnl = closedPnl
        self.fillCount = fillCount
        self.leverage = leverage
        self.createdAt = createdAt
    }
    
    public var id: Number
    public var userId: Number
    public var orderId: Number
    public var symbol: String
    public var side: BybitSide
    public var qty: Number
    public var orderPrice: Number
    public var orderType: OrderType
    public var execType: String
    public var closedSize: Number
    public var cumEntryValue: Number
    public var avgEntryPrice: Number
    public var cumExitValue: Number
    public var avgExitPrice: Number
    public var closedPnl: Number
    public var fillCount: Number
    public var leverage: Number
    public var createdAt: Number
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
