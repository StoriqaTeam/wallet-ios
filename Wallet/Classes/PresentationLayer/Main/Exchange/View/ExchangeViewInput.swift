//
//  ExchangeViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeViewInput: class, Presentable {
    func setupInitialState()
    func setNewPage(_ index: Int)
}
