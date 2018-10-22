//
//  PinSetupInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinSetupInteractor {
    weak var output: PinSetupInteractorOutput!
    
    private var isFirstEntry = true
    private let qiuckLaunchProvider: QuickLaunchProviderProtocol
    
    init(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        self.qiuckLaunchProvider = qiuckLaunchProvider
    }
}


// MARK: - PinSetupInteractorInput

extension PinSetupInteractor: PinSetupInteractorInput {
    
    func pinInputCompleted(_ pin: String) {
        if isFirstEntry {
            isFirstEntry = false
            qiuckLaunchProvider.setPin(pin)
            output.enterConfirmationPin()
            
        } else if qiuckLaunchProvider.isPinConfirmed(pin) {
            
            if qiuckLaunchProvider.isBiometryAvailable() {
                output.showBiometryQuickSetup(qiuckLaunchProvider: qiuckLaunchProvider)
            } else {
                output.showAuthorizedZone()
            }
            
        } else {
            isFirstEntry = true
            output.enterPinAgain()
        }
    }
    
}
