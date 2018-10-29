//
//  QRScannerRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class QRScannerRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - QRScannerRouterInput

extension QRScannerRouter: QRScannerRouterInput {
    
}
