//
//  ApplicationConfigurator.swift
//  Wallet
//
//  Created by Storiqa on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import AlamofireNetworkActivityIndicator

class ApplicationConfigurator: Configurable {
    
    private let keychain: KeychainProviderProtocol
    private let defaults: DefaultsProviderProtocol
    private let shortPollingTimer: ShortPollingTimerProtocol
    let app: Application
    
    init(app: Application) {
        self.keychain = app.keychainProvider
        self.defaults = app.defaultsProvider
        self.shortPollingTimer = app.shortPollingTimer
        self.app = app
    }
    
    func configure() {
        setInitialVC()
        setGID()
        setupChannel()
    }    
}


// MARK: - Private methods
extension ApplicationConfigurator {
    
    private func setInitialVC() {
        if defaults.isFirstLaunch {
            defaults.isFirstLaunch = false
            keychain.deleteAll()
            FirstLaunchModule.create(app: app).present()
        } else if isPinSet() {
            PinInputModule.create(app: app).present()
        } else {
            LoginModule.create(app: app).present()
        }
    }

    private func isPinSet() -> Bool {
        return keychain.pincode != nil
    }
    
    private func setGID() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        GIDSignIn.sharedInstance().clientID = Constants.NetworkAuth.kGoogleClientId
    }
    
    private func setupChannel() {
        let shortPollingChannel = app.channelStorage.shortPollingChannel
        self.shortPollingTimer.setOutputChannel(shortPollingChannel)
        self.shortPollingTimer.startPolling()
    }
}
