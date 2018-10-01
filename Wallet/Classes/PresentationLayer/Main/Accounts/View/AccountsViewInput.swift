//
//  AccountsViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AccountsViewInput: class, Presentable {
    func setupInitialState(numberOfPages: Int)
    func setNewPage(_ index: Int)
}
