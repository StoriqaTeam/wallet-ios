//
//  QRScannerViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol QRScannerViewInput: class, Presentable {
    func setupInitialState(message: String)
    func setPreviewLayer(_ previewLayer: CALayer)
    func changeAimColor(_ color: UIColor)
    func changeMessage(_ text: String)
}
