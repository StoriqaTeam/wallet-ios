//
//  MyWalletViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol MyWalletViewInput: class, Presentable {
    func setupInitialState()
    func reloadWithAccounts()
    func setNavigationBarTopSpace(_ topSpace: CGFloat)
    func setNavigationBarHidden(_ hidden: Bool)
}
