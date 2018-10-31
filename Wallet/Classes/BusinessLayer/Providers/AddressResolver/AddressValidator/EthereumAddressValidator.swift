//
//  EthereumAddressValidator.swift
//  Wallet
//
//  Created by Storiqa on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EthereumAddressValidator: AddressValidatorProtocol {
    func isValid(address: String) -> Bool {
        return address.count == 42 && address.prefix(2) == "0x"
                                   && !Data(hex: address).isEmpty
    }
}
