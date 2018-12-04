//
//  PinInputPasswordInputViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinInputViewOutput: class {
    func viewIsReady()
    func pinContainer(_ pinContainer: PinContainerView)
    func inputComplete(_ password: String)
    func iForgotPinPressed()
    func viewDidAppear()
}
