//
//  BiometricAuthProviderFactory.swift
//  Wallet
//
//  Created by Storiqa on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol BiometricAuthProviderFactoryProtocol {
    func create() -> BiometricAuthProviderProtocol
}

class BiometricAuthProviderFactory: BiometricAuthProviderFactoryProtocol {
    
    func create() -> BiometricAuthProviderProtocol {
        return BiometricAuthProvider()
    }
}
