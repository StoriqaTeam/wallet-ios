//
//  DefaultsProvider.swift
//  Wallet
//
//  Created by Storiqa on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol DefaultsProviderProtocol: class {
    var isFirstLaunch: Bool { get set }
    var isBiometryAuthEnabled: Bool { get set }
    var fiatISO: String { get set }
    var lastTxTimastamp: TimeInterval? { get set }
    var socialAuthProvider: SocialNetworkTokenProvider? { get set }
    var deviceId: String { get set }
    var isFirstTransactionsLoad: Bool { get set }
    
    func clear()
}

class DefaultsProvider: DefaultsProviderProtocol {
    
    enum DefaultsKey: String, CaseIterable {
        case isFirstLaunch
        case isBiometryAuthEnabled
        case fiatISO
        case lastTxTimastamp
        case socialAuthProvider
        case deviceId
        case isFirstTransactionsLoad
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
    
    var lastTxTimastamp: TimeInterval? {
        get {
            return getDouble(.lastTxTimastamp)
        }
        set {
            setDouble(newValue, key: .lastTxTimastamp)
        }
    }
    
    var socialAuthProvider: SocialNetworkTokenProvider? {
        get {
            guard let strValue = getString(.socialAuthProvider),
                let provider = SocialNetworkTokenProvider(strValue) else {
                    return nil
            }
            
            return provider
        }
        set {
            setString(newValue?.name, key: .socialAuthProvider)
        }
    }
    
    var deviceId: String {
        get {
            return getString(.deviceId)!
        }
        set {
            setString(newValue, key: .deviceId)
        }
    }
    
    var isFirstTransactionsLoad: Bool {
        get {
            guard let first = getBool(.isFirstTransactionsLoad) else { return true }
            return first
        }
        set {
            setBool(newValue, key: .isFirstTransactionsLoad)
        }
    }
    
    func clear() {
        isBiometryAuthEnabled = false
        socialAuthProvider = nil
        lastTxTimastamp = nil
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
    
    private func getDouble(_ key: DefaultsKey) -> Double? {
        guard isKeyPresentInUserDefaults(key: key) else {
            return nil
        }
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    
    private func setDouble(_ value: Double?, key: DefaultsKey) {
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
