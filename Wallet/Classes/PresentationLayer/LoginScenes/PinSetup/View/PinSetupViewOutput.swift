//
//  PinSetupViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinSetupViewOutput: class {
    func viewIsReady()
    func pinContainer(_ pinContainer: PinContainerView)
}
