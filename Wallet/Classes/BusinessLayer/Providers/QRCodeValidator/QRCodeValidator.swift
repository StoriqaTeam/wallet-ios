//
//  QRCodeValidator.swift
//  Wallet
//
//  Created by user on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol QRCodeValidatorProtocol {
    func isBTCWalletAddress(_ code: String) -> Bool
    func isETHWalletAddress(_ code: String) -> Bool
}

class QRCodeValidator: QRCodeValidatorProtocol {

    func isBTCWalletAddress(_ code: String) -> Bool {
        //TODO: isBTCWalletAddress
        return true
    }
    
    func isETHWalletAddress(_ code: String) -> Bool {
        //TODO: isBTCWalletAddress
        return true
    }

}
