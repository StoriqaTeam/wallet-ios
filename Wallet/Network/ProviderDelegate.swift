//
//  ProviderDelegate.swift
//  Wallet
//
//  Created by user on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ProviderDelegate: class {
    func providerSucceed()
    func providerFailedWithMessage(_ message: String)
    func providerFailedWithApiErrors(_ errors: [ResponseAPIError.Message])
}
