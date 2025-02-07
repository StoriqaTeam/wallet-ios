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
    private let userKeyManager: UserKeyManagerProtocol
    private let accountsProvider: AccountsProviderProtocol
    
    let app: Application
    
    init(app: Application) {
        self.keychain = app.keychainProvider
        self.defaults = app.defaultsProvider
        self.userKeyManager = app.userKeyManager
        self.accountsProvider = app.accountsProvider
        self.app = app
    }
    
    func configure() {
        setInitialVC()
        setGID()
        setApperance()
    }
}


// MARK: - Private methods
extension ApplicationConfigurator {
    
    private func setInitialVC() {
        if defaults.isFirstLaunch {
            
            defaults.isFirstLaunch = false
            defaults.deviceId = UUID().uuidString
            keychain.deleteAll()
            userKeyManager.clearUserKeyData()
            FirstLaunchModule.create(app: app).present()
            
        } else if isPinSet() && !accountsProvider.getAllAccounts().isEmpty {
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
    
    private func setApperance() {
        for state: UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(
                [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0.001)],
                for: state)
        }
        
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.tintColor = Theme.Color.NavigationBar.statusBar
            statusBar.setValue(Theme.Color.NavigationBar.statusBar, forKey: "foregroundColor")
        }
    }
}
