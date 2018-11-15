//
//  BiometricAuthProviderFactory.swift
//  Wallet
//
//  Created by Tata Gri on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol BiometricAuthProviderFactoryProtocol {
    func create() -> BiometricAuthProviderProtocol
}

class BiometricAuthProviderFactory: BiometricAuthProviderFactoryProtocol {
    
    private let errorParser: BiometricAuthErrorParserProtocol
    
    init(errorParser: BiometricAuthErrorParserProtocol) {
        self.errorParser = errorParser
    }
    
    func create() -> BiometricAuthProviderProtocol {
        return BiometricAuthProvider(errorParser: errorParser)
    }
}
