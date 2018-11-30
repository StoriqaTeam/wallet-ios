//
//  LoginLoginRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LoginRouterInput: class {
    func showRegistration()
    func showPasswordRecovery(from viewController: UIViewController)
    func showQuickLaunch(from viewController: UIViewController)
    func showPinQuickLaunch(from viewController: UIViewController)
    func showAuthorizedZone()
    func showFailurePopup(message: String,
                          popUpDelegate: PopUpRegistrationFailedVMDelegate,
                          from viewController: UIViewController)
    func showDeviceRegister(popUpDelegate: PopUpDeviceRegisterVMDelegate,
                            from viewController: UIViewController)
    func showDeviceRegisterEmailSent(from viewController: UIViewController)
    func showDeviceRegisterFailedSendEmail(message: String,
                                           popUpDelegate: PopUpDeviceRegisterFailedSendEmailVMDelegate,
                                           from viewController: UIViewController)
    func showEmailNotVerified(popUpDelegate: PopUpResendConfirmEmailVMDelegate,
                              from viewController: UIViewController)
    func showEmailSengingSuccess(email: String,
                                 popUpDelegate: PopUpRegistrationSuccessVMDelegate,
                                 from viewController: UIViewController)
    func showEmailSengingFailure(message: String,
                                 from viewController: UIViewController)
}
