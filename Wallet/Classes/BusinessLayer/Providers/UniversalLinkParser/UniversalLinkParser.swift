//
//  UniversalLinkParser.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum UniversalLink {
    case verifyEmail(token: String)
    case resetPassword(token: String)
}

protocol UniversalLinkParserProtocol {
    func parse(link: URL?) -> UniversalLink?
}

class UniversalLinkParser: UniversalLinkParserProtocol {
    func parse(link: URL?) -> UniversalLink? {
        guard var link = link else {
            log.warn("Universal Link is nil")
            return nil
        }
        
        let token = link.lastPathComponent
        link.deleteLastPathComponent()
        
        let type = link.lastPathComponent
        switch type {
        case "verify_email":
            return .verifyEmail(token: token)
        case "password_reset":
            return .resetPassword(token: token)
        default:
            log.warn("Invalid Universal Link: \(link)")
            return nil
        }
    }
}
