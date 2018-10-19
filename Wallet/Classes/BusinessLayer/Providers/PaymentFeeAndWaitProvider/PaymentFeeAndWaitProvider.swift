//
//  PaymentFeeAndWaitProvider.swift
//  Wallet
//
//  Created by Tata Gri on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PaymentFeeAndWaitProviderProtocol {
    func updateSelectedForCurrency(_ currency: Currency)
    func getValuesCount() -> Int
    func getIndex(fee: Decimal) -> Int
    func getFee(index: Int) -> Decimal
    func getWait(fee: Decimal) -> String
}

class FakePaymentFeeAndWaitProvider: PaymentFeeAndWaitProviderProtocol {
    
    private let satoshi = 0.000_000_01
    private let aproxBlockBytes = 220.0
    private let gwei = 0.000_000_001
    private let transferGas = 21000.0
    
    private lazy var stqFeeWait: [Decimal: String] = [
        1: "41s",
        2: "37s",
        3: "33s",
        4: "29s",
        5: "25s",
        6: "22s",
        7: "20s",
        8: "17s",
        9: "15s"
    ]
    private lazy var btcFeeWait: [Decimal: String] = [
        Decimal(12 * satoshi * aproxBlockBytes): "60m",
        Decimal(13 * satoshi * aproxBlockBytes): "45m",
        Decimal(14 * satoshi * aproxBlockBytes): "30m",
        Decimal(15 * satoshi * aproxBlockBytes): "20m",
        Decimal(16 * satoshi * aproxBlockBytes): "10m"
    ]
    private lazy var ethFeeWait: [Decimal: String] = [
        Decimal(2 * gwei * transferGas): "41s",
        Decimal(3 * gwei * transferGas): "37s",
        Decimal(4 * gwei * transferGas): "33s",
        Decimal(5 * gwei * transferGas): "29s",
        Decimal(6 * gwei * transferGas): "25s",
        Decimal(7 * gwei * transferGas): "22s",
        Decimal(8 * gwei * transferGas): "20s",
        Decimal(9 * gwei * transferGas): "17s",
        Decimal(10 * gwei * transferGas): "15s"
    ]
    
    private var selected = [Decimal: String]()
    
    func updateSelectedForCurrency(_ currency: Currency) {
        switch currency {
        case .stq:
            selected = stqFeeWait
        case .btc:
            selected = btcFeeWait
        case .eth:
            selected = ethFeeWait
        case .fiat:
            selected = [Decimal: String]()
        }
    }
    
    func getValuesCount() -> Int {
        return selected.count
    }
    
    func getIndex(fee: Decimal) -> Int {
        let paymentFeeValues = Array(selected.keys).sorted()
        let index = paymentFeeValues.firstIndex(of: fee)!
        return index
    }
    
    func getFee(index: Int) -> Decimal {
        let paymentFeeValues = Array(selected.keys).sorted()
        return paymentFeeValues[index]
        
    }
    
    func getWait(fee: Decimal) -> String {
        return selected[fee]!
    }
    
}
