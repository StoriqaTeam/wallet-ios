//
//  EditProfileRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EditProfileRouterInput: class {
    func showFailure(message: String,
                     from viewController: UIViewController)
}
