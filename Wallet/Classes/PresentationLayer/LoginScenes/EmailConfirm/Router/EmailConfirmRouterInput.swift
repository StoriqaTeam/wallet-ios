//
//  EmailConfirmRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol EmailConfirmRouterInput: class {
    func showSuccess(popUpDelegate: PopUpEmailConfirmSuccessVMDelegate,
                     from viewController: UIViewController)
    func showFailure(message: String,
                     popUpDelegate: PopUpEmailConfirmFailedVMDelegate,
                     from viewController: UIViewController)
    func showLogin()
}
