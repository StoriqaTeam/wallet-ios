//
//  PaymentFeeViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PaymentFeeViewOutput: class {
    func viewIsReady()
    func editButtonPressed()
    func sendButtonPressed()
    func newFeeSelected(_ index: Int)
    func willMoveToParentVC()
}
