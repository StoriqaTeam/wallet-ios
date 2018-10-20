//
//  DefaultsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol DefaultsProviderProtocol: class {
    var isFirstLaunch: Bool { get set }
    var isQuickLaunchShown: Bool { get set }
    var isBiometryAuthEnabled: Bool { get set }
    var authToken: String? { get set }
    var fiatISO: String { get set }
}

class DefaultsProvider: DefaultsProviderProtocol {
    
    enum DefaultsKey: String, CaseIterable {
        case isFirstLaunch
        case isQuickLaunchShown
        case isBiometryAuthEnabled
        case authToken
        case fiatISO
    }
    
    var authToken: String? {
        get {
            return getString(.authToken)
        }
        set {
            setString(newValue, key: .authToken)
        }
    }
    
    var isFirstLaunch: Bool {
        get {
            guard let first = getBool(.isFirstLaunch) else { return true }
            return first
        }
        set {
            setBool(newValue, key: .isFirstLaunch)
        }
    }
    
    var isQuickLaunchShown: Bool {
        get {
            guard let shown = getBool(.isQuickLaunchShown) else { return false }
            return shown
        }
        set {
            setBool(newValue, key: .isQuickLaunchShown)
        }
    }
    
    var isBiometryAuthEnabled: Bool {
        get {
            guard let enabled = getBool(.isBiometryAuthEnabled) else { return false }
            return enabled
        }
        set {
            setBool(newValue, key: .isBiometryAuthEnabled)
        }
    }
    
    var fiatISO: String {
        get {
            if let fiat = getString(.fiatISO) {
                return fiat
            }
            
            let defaultFiat = "USD"
            setString(defaultFiat, key: .fiatISO)
            return defaultFiat
        }
        set {
            setString(newValue, key: .fiatISO)
        }
    }
    
}


// MARK: - Private methods

extension DefaultsProvider {
    private func getString(_ key: DefaultsKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    private func setString(_ value: String?, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    private func getArray(_ key: DefaultsKey) -> [String]? {
        return UserDefaults.standard.array(forKey: key.rawValue) as? [String]
    }
    
    private func setArray(_ value: [String]?, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    private func getBool(_ key: DefaultsKey) -> Bool? {
        guard isKeyPresentInUserDefaults(key: key) else {
            return nil
        }
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    private func setBool(_ value: Bool, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private func isKeyPresentInUserDefaults(key: DefaultsKey) -> Bool {
        return UserDefaults.standard.object(forKey: key.rawValue) != nil
    }
}
