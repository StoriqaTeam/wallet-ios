//
//  QRScannerInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol QRScannerInteractorOutput: class {
    func codeDetected()
    func failed(title: String, message: String)
}
