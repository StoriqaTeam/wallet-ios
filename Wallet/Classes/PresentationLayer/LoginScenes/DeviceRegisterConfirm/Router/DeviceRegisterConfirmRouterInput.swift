//
//  DeviceRegisterConfirmRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol DeviceRegisterConfirmRouterInput: class {
    func showSuccess(popUpDelegate: PopUpConfirmDeviceRegisterSucceedVMDelegate,
                     from viewController: UIViewController)
    func showFailure(message: String,
                     popUpDelegate: PopUpEmailConfirmFailedVMDelegate,
                     from viewController: UIViewController)
    func showLogin()
}
