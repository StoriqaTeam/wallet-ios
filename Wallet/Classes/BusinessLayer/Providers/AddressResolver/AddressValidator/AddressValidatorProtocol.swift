//
//  AddressValidatorProtocol.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AddressValidatorProtocol {
    func isValid(address: String) -> Bool
}
