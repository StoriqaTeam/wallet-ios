//
//  DefaultsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol DefaultsProviderProtocol {
    var isFirstLaunch: Bool { set get }
}

class DefaultsProvider: DefaultsProviderProtocol {
    
    enum DefaultsKey: String, EnumCollection {
        case isFirstLaunch
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
}


// MARK: -  Private methods

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
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    private func setBool(_ value: Bool, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

