//
//  PaymentFeeInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PaymentFeeInteractorOutput: class {
    func sendTxFailed(message: String)
    func sendTxSucceed()
}
