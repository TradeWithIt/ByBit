//
//  BybitPublicClient.swift
//  TradeWithMe
//
//  Created by Szymon on 26/2/2022.
//

import Foundation

public struct BybitPublicClient: ClientProtocol {
    public let environment: BybitEnvironment
    public let timeoutInterval: TimeInterval

    internal init(env: BybitEnvironment, timeoutInterval: TimeInterval) {
        var publicEnv = env
        publicEnv.key = env.key
        publicEnv.secret = env.secret
        publicEnv.timestamp = nil
        self.environment = publicEnv
        self.timeoutInterval = timeoutInterval
    }
}
