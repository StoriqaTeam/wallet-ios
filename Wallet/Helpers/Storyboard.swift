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
    
    var name: String {
        switch self {
        case .main:
            return "Main"
        }
    }
    
    func viewController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}
