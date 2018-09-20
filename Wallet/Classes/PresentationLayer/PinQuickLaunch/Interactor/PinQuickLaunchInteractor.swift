//
//  PinQuickLaunchInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinQuickLaunchInteractor {
    weak var output: PinQuickLaunchInteractorOutput!
    
    private let qiuckLaunchProvider: QuickLaunchProviderProtocol
    init(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        self.qiuckLaunchProvider = qiuckLaunchProvider
    }
    
}


// MARK: - PinQuickLaunchInteractorInput

extension PinQuickLaunchInteractor: PinQuickLaunchInteractorInput {
    
    func getProvider() -> QuickLaunchProviderProtocol {
        return qiuckLaunchProvider
    }
    
    func cancelSetup() {
        
        if qiuckLaunchProvider.isBiometryAvailable() {
            output.showBiometryQuickSetup(qiuckLaunchProvider: qiuckLaunchProvider)
        } else {
            output.showAuthorizedZone()
        }
    }
    
}
