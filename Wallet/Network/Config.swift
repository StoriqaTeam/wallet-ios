//
//  NetworkConfig.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Slog

let facebookAppId = "fb425217154570731"
//TODO: нужен новый client id от гугла, специально для приложения
let googleClientId = "245895770851-38n6to49r49reccloeepeutocvk2hne3.apps.googleusercontent.com"
let log = Slog(level: .debug, useEmoji: true)

class NetworkConfig {
    enum Cluster: String {
        case stable
        case nightly
    }
    
    static var cluster: Cluster = .nightly
    static var port: String = "60443"
    
    static var url: String {
        return "https://\(cluster.rawValue).stq.cloud:\(port)"
    }
    
    static var graphqlUrl: String {
        return url + "/graphql"
    }
    
}
