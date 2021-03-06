//
//  Bybit+Public.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation
import API

public struct BybitPublic<T: Codable>: Codable {
    public init(retCode: Int, retMsg: String, extCode: String, extInfo: String, timeNow: String, result: T) {
        self.retCode = retCode
        self.retMsg = retMsg
        self.extCode = extCode
        self.extInfo = extInfo
        self.timeNow = timeNow
        self.result = result
    }
    
    public let retCode: Int
    public let retMsg: String
    public let extCode: String
    public let extInfo: String
    public let timeNow: String
    
    public let result: T
}

public struct BybitPublicResult: Codable {
    public init(id: Int, title: String, link: String, summary: String, createdAt: String) {
        self.id = id
        self.title = title
        self.link = link
        self.summary = summary
        self.createdAt = createdAt
    }
    
    public let id: Int
    public let title: String
    public let link: String
    public let summary: String
    public let createdAt: String
}

public struct BybitResult<T: Codable>: Codable {
    public init(isValid: Bool, result: T) {
        self.isValid = isValid
        self.result = result
    }
    
    public let isValid: Bool
    public let result: T
}

public struct BybitPage<T: Codable>: Codable {
    public init(currentPage: Int, data: T?) {
        self.currentPage = currentPage
        self.data = data
    }
    
    public let currentPage: Int
    public let data: T?
}



extension BybitPublicClient {
    /// Get Bybit server time.
    public func time() async throws -> BybitPublic<[String: String]> {
        return try await get("/v2/public/time")
    }
    
    /// Get Bybit OpenAPI announcements in the last 30 days in reverse order.
    public func announcement() async throws -> BybitPublic<[BybitPublicResult]> {
        return try await get("/v2/public/announcement")
    }
}
