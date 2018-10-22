//
//  BiometryQuickLaunchInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class BiometryQuickLaunchInteractor {
    weak var output: BiometryQuickLaunchInteractorOutput!
    
    private let qiuckLaunchProvider: QuickLaunchProviderProtocol
    
    init(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        self.qiuckLaunchProvider = qiuckLaunchProvider
    }
}


// MARK: - BiometryQuickLaunchInteractorInput

extension BiometryQuickLaunchInteractor: BiometryQuickLaunchInteractorInput {
    
    func getBiometryType() -> BiometricAuthType {
        return qiuckLaunchProvider.getBiometryType()
    }
    
    func activateBiometryLogin() {
        qiuckLaunchProvider.activateBiometryLogin()
    }
    
}
