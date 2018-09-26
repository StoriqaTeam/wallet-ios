//
//  QRScannerModuleInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol QRScannerModuleInput: class {
    var output: QRScannerModuleOutput? { get set }
    func present(from viewController: UIViewController)
}
