//
//  DepositViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol DepositViewInput: class, Presentable {
    func setupInitialState(numberOfPages: Int)
    func setNewPage(_ index: Int)
    func setAddress(_ address: String)
    func setQrCode(_ qrCode: UIImage)
}
