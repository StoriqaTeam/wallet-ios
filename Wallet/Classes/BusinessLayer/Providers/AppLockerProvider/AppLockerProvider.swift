//
//  AppLockerProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 30/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AppLockerProviderProtocol {
    func setLock()
    func autolock()
}

class AppLockerProvider: AppLockerProviderProtocol {
    
    private let app: Application
    private let keychain: KeychainProviderProtocol
    private let unlockPeriod: TimeInterval = 60
    private var lastUnlockDate: Date = Date.distantPast

    init(app: Application) {
        self.app = app
        self.keychain = app.keychainProvider
    }
    
    func setLock() {
         self.lastUnlockDate = Date()
    }

    func autolock() {
        if shouldLock() {
            lock()
        }
    }
}

extension AppLockerProvider {

    private func shouldLock() -> Bool {
        return  lastUnlockDate.addingTimeInterval(unlockPeriod) < Date()
                                            && keychain.pincode != nil

    }

    private func lock() {
        let rootViewController = AppDelegate.currentWindow.rootViewController!
        PinInputModule.create(app: app).presentModal(from: rootViewController)
    }
}
