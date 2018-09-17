//
//  Storyboard.swift
//  Wallet
//
//  Created by user on 22.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard {
    case main
    case passwordRecovery
    case quickLaunch
    
    var name: String {
        switch self {
        case .main:
            return "Main"
        case .passwordRecovery:
            return "PasswordRecovery"
        case .quickLaunch:
            return "QuickLaunch"
        }
    }
    
    func viewController(identifier: String, fatal: Bool = false) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if fatal {
            let vc = storyboard.instantiateViewController(withIdentifier: identifier)
            return vc
        } else {
            if let availableIdentifiers = storyboard.value(forKey: "identifierToNibNameMap") as? [String: Any] {
                if availableIdentifiers[identifier] != nil {
                    let vc = storyboard.instantiateViewController(withIdentifier: identifier)
                    return vc
                }
            }
            
            Fallback.couldNotInstantiateViewController(identifier: identifier, storyBoard: name, fatal: fatal)
            return nil
        }
    }
}
