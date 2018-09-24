//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordRecoveryConfirmRouterInput: class {
    func showSuccess(popUpDelegate: PopUpPasswordRecoveryConfirmSuccessVMDelegate,
                     from viewController: UIViewController)
    func showFailure(message: String,
                     popUpDelegate: PopUpPasswordRecoveryConfirmFailedVMDelegate,
                     from viewController: UIViewController)
    func showAuthorizedZone()
}
