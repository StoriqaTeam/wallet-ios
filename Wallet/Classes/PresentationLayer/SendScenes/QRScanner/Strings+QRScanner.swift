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
                                                              value: "Place QR-code inside the white frame. \nTry not to shake your phone.",
                                                              comment: "QR code hint message label title")
        
        static let wrongQrMessageTitle = NSLocalizedString("QRScanner.wrongQrMessageTitle",
                                                           tableName: "QRScanner",
                                                           value: "Currency of scanned address doesn't match the currency you are trying to transfer.",
                                                           comment: "QR code hint message label title")
        
        static let navigationBarTitle = NSLocalizedString("QRScanner.navigationBarTitle",
                                                          tableName: "QRScanner",
                                                          value: "Scan QR-code",
                                                          comment: "Navigation bar title")
        
        static let okMessage = NSLocalizedString("QRScanner.okMessage",
                                                 tableName: "QRScanner",
                                                 value: "Ok",
                                                 comment: "Okey message")
        
        static let scanningNotSupportTitle = NSLocalizedString("QRScanner.scanningNotSupportTitle",
                                                               tableName: "QRScanner",
                                                               value: "Scanning not supported",
                                                               comment: "Alert Scan not support title")
        
        static let scanningNotSupportMessage = NSLocalizedString("QRScanner.scanningNotSupportMessage",
                                                                 tableName: "QRScanner",
                                                                 value: "It seems your device does not support QR-code scanning.",
                                                                 comment: "Alert Scan not support message")
        
        static let noCameraAccessTitle = NSLocalizedString("QRScanner.noCameraAccessTitle",
                                                           tableName: "QRScanner",
                                                           value: "No camera access",
                                                           comment: "Alert no camera access title")
        
        static let noCameraAccessMessage = NSLocalizedString("QRScanner.noCameraAccessMessage",
                                                           tableName: "QRScanner",
                                                           value: "It seems you’ve restricted access to your camera. Enable it in Settings.",
                                                           comment: "Alert no camera access message")
        
        
    }
}
