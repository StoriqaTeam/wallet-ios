//
//  BitcoinAddressValidator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class BitcoinAddressValidator: AddressValidatorProtocol {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
   func isValid(address: String)  -> Bool {
        let data = Base58.decode(address)
        if data.count != 25 { return false }
        let versionByte = data[0]
    
        if network == .btcTestnet {
            return versionByte == 111 || versionByte == 196
        }
        
        if network == .btcMainnet {
            return versionByte == 0 || versionByte == 5
        }
        
        return false
    }
    
}
