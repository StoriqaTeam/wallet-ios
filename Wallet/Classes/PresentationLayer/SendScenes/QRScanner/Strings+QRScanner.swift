//
//  Strings+QRScanner.swift
//  Wallet
//
//  Created by Storiqa on 08/11/2018.    
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum QRScanner {
        static let qrCodeHintMessageTitle = NSLocalizedString("QRScanner.qrCodeHintMessageTitle",
                                                              tableName: "QRScanner",
                                                              value: "Place QR-code inside white frame. Try not to shake your phone.",
                                                              comment: "QR code hint message label title")
        
        static let wrongQrMessageTitle = NSLocalizedString("QRScanner.wrongQrMessageTitle",
                                                           tableName: "QRScanner",
                                                           value: "Currency of scanned address doesn't match previously selected receiver currency.",
                                                           comment: "QR code hint message label title")
        
        static let navigationBarTitle = NSLocalizedString("QRScanner.navigationBarTitle",
                                                          tableName: "QRScanner",
                                                          value: "Scan QR-code",
                                                          comment: "Navigation bar title")
        static let okMessage = NSLocalizedString("QRScanner.okMessage",
                                                 tableName: "QRScanner",
                                                 value: "Ok",
                                                 comment: "Okey message")
        
    }
}
