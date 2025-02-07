//
//  AppLockerProvider.swift
//  Wallet
//
//  Created by Storiqa on 30/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AppLockerProviderProtocol {
    func setLock()
    func autolock()
    func setIsLocked(_ isLocked: Bool)
}

class AppLockerProvider: AppLockerProviderProtocol {
    
    private let app: Application
    private let keychain: KeychainProviderProtocol
    private let unlockPeriod: TimeInterval = 60
    private var lastUnlockDate: Date = Date.distantPast
    private var isLocked = false

    init(app: Application) {
        self.app = app
        self.keychain = app.keychainProvider
    }
    
    func setIsLocked(_ isLocked: Bool) {
        self.isLocked = isLocked
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
        return !isLocked &&
            lastUnlockDate.addingTimeInterval(unlockPeriod) < Date() &&
            keychain.pincode != nil

    }

    private func lock() {
        let rootViewController = AppDelegate.currentWindow.rootViewController!
        PinInputModule.create(app: app).presentModal(from: rootViewController)
    }
}
