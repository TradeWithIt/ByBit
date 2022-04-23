//
//  BybitClient.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation
import API

public struct BybitClient: ClientProtocol {
    public var environment: BybitEnvironment
    public let `public`: BybitPublicClient
    public let timeoutInterval: TimeInterval
    
    public init(_ environment: BybitEnvironment, timeoutInterval: TimeInterval = 5, publicTimeoutInterval: TimeInterval = 5) async throws {
        let publicClient = BybitPublicClient(env: environment, timeoutInterval: publicTimeoutInterval)
        let clock = try await publicClient.time()
        let now = Date()
        var localEnvironment = environment
        localEnvironment.timestamp = TimeInterval(clock.timeNow)
        localEnvironment.clockQueryTime = now
        self.timeoutInterval = timeoutInterval
        self.environment = localEnvironment
        self.public = publicClient
    }
}
