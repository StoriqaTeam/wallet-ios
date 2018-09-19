//
//  ApplicationConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import AlamofireNetworkActivityIndicator

class ApplicationConfigurator: Configurable {
    
    private let keychain: KeychainProvider
    private let defaults: DefaultsProvider
    
    init(keychain: KeychainProvider, defaults: DefaultsProvider) {
        self.keychain = keychain
        self.defaults = defaults
    }
    
    func configure() {
        setInitialVC()
        setGID()
    }
}


// MARK: - Private methods
extension ApplicationConfigurator {
    
    private func setInitialVC() {
        if defaults.isFirstLaunch {
            defaults.isFirstLaunch = false
            FirstLaunchModule.create().present()
        } else if isPinSet() {
            PasswordInputModule.create().present()
        } else {
            LoginModule.create().present()
        }
    }
    
    private func isPinSet() -> Bool {
        return keychain.pincode != nil
    }
    
    private func setGID() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        GIDSignIn.sharedInstance().clientID = googleClientId
        GIDSignIn.sharedInstance().delegate = AppDelegate.currentDelegate
    }
}
