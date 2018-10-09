//
//  ProfileRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ProfileRouterInput: class {
    func showSettings(from viewController: UIViewController)
    func signOut()
}
