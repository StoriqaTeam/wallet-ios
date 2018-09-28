//
//  EthereumAddressValidator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EthereumAddressValidator: AddressValidatorProtocol {
    func isValid(address: String) -> Bool {
        return address.count == 42 && address.prefix(2) == "0x"
                                   && Data(hex: address).count > 0
    }
}
