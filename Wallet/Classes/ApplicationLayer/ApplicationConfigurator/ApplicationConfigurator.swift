//
//  ApplicationConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class ApplicationConfigurator: Configurable {
    
    private var isPinSet: Bool {
        //TODO: проверка, установлен ли пин
        return false
    }
    
    private var isFirstLaunch: Bool {
        set {
            UserDefaults.standard.set(isFirstLaunch, forKey: Constants.Keys.kIsFirstLaunch)
        }
        get {
            if let _ = UserDefaults.standard.object(forKey: Constants.Keys.kIsFirstLaunch) {
                //not a firstLaunch if key has any value
                return false
            } else {
                return true
            }
        }
    }
    
    func configure() {
        setInitialVC()
    }
}


// MARK: - Private methods
extension ApplicationConfigurator {
    
    private func setInitialVC() {        
        if isFirstLaunch {
            isFirstLaunch = false
            FirstLaunchModule.create().present()
        } else if isPinSet {
            PasswordInputModule.create().present()
        } else {
            LoginModule.create().present()
        }
    }
}
