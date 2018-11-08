//
//  ChangePasswordRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ChangePasswordRouterInput: class {
    func showSuccess(popUpDelegate: PopUpChangePasswordSuccessVMDelegate,
                     from viewController: UIViewController)
    func showFailure(message: String,
                     from viewController: UIViewController)
}
