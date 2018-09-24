//
//  PopUpViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PopUpViewInput: class, Presentable {
    func setupInitialState(vm: PopUpViewModelProtocol)
}
