//
//  PasswordEmailRecoveryPasswordEmailRecoveryRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordEmailRecoveryRouterInput: class {
    func showSuccess(popUpDelegate: PopUpPasswordEmailRecoverySuccessVMDelegate,
                     from viewController: UIViewController)
    func showFailure(message: String,
                     popUpDelegate: PopUpPasswordEmailRecoveryFailedVMDelegate,
                     from viewController: UIViewController)
}
