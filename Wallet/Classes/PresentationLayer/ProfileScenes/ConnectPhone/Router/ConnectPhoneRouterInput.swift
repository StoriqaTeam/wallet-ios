//
//  ConnectPhoneRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ConnectPhoneRouterInput: class {
    func showFailure(message: String,
                     from viewController: UIViewController)
}
