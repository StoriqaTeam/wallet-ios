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
    
    private let keychain: KeychainProviderProtocol
    private let defaults: DefaultsProviderProtocol
    
    init(keychain: KeychainProviderProtocol, defaults: DefaultsProviderProtocol) {
        self.keychain = keychain
        self.defaults = defaults
    }
    
    func configure() {
//        MainTabBarModule.create().present()
        setInitialVC()
        setGID()
    }
}


// MARK: - Private methods
extension ApplicationConfigurator {
    
    private func setInitialVC() {
        //TODO: delete
//        defaults.isFirstLaunch = true
//        defaults.isQuickLaunchShown = false
        
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
        GIDSignIn.sharedInstance().clientID = Constants.NetworkAuth.kGoogleClientId
    }
}
