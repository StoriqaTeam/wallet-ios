//
//  CryproAddressResolver.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol CryptoAddressResolverProtocol {
    func resove(address: String) -> Currency?
}


class CryptoAddressResolver: CryptoAddressResolverProtocol {
    
    private let btcAddressValidator: AddressValidatorProtocol
    private let ethAddressValidator: AddressValidatorProtocol
    
    init(btcAddressValidator: AddressValidatorProtocol, ethAddressValidator: AddressValidatorProtocol) {
        self.btcAddressValidator = btcAddressValidator
        self.ethAddressValidator = ethAddressValidator
    }
    
    // @dev returns nil in case unknowed data
    func resove(address: String) -> Currency? {
        if btcAddressValidator.isValid(address: address) {
            return .btc
        }
        
        if ethAddressValidator.isValid(address: address) {
            return .eth
        }
        
        return nil
    }
}
