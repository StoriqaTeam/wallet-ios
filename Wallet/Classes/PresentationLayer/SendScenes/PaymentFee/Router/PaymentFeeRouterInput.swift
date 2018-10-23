//
//  PaymentFeeRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PaymentFeeRouterInput: class {
    func showConfirm(amount: String,
                     address: String,
                     popUpDelegate: PopUpSendConfirmVMDelegate,
                     from viewController: UIViewController)
}
