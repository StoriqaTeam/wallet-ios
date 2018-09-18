//
//  PinValidationProvider.swift
//  Wallet
//
//  Created by user on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PinValidationProviderProtocol {
    func pinIsValid(_ pin: String) -> Bool
}

class PinValidationProvider: PinValidationProviderProtocol {
    func pinIsValid(_ pin: String) -> Bool {
        //TODO: stub
        return pin == "1234"
    }
}
