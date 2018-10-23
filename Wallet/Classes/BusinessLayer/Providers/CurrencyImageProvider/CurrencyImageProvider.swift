//
//  CurrencyImageProvider.swift
//  Wallet
//
//  Created by Tata Gri on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyImageProviderProtocol {
    func smallImage(for currency: Currency) -> UIImage
    func mediumImage(for currency: Currency) -> UIImage
}

class CurrencyImageProvider: CurrencyImageProviderProtocol {
    
    func smallImage(for currency: Currency) -> UIImage {
        switch currency {
        case .btc:
            return #imageLiteral(resourceName: "currency_btc_small")
        case .eth:
            return #imageLiteral(resourceName: "currency_eth_small")
        case .stq:
            return #imageLiteral(resourceName: "currency_stq_small")
        case .fiat:
            return #imageLiteral(resourceName: "currency_fiat_small")
        }
    }
    
    func mediumImage(for currency: Currency) -> UIImage {
        switch currency {
        case .btc:
            return #imageLiteral(resourceName: "currency_btc_medium")
        case .eth:
            return #imageLiteral(resourceName: "currency_eth_medium")
        case .stq:
            return #imageLiteral(resourceName: "currency_stq_medium")
        case .fiat:
            return #imageLiteral(resourceName: "currency_fiat_medium")
        }
    }
    
}
