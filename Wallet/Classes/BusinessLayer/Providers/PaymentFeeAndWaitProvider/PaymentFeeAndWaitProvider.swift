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
    func getWait(fee: Decimal) -> Decimal
}

class FakePaymentFeeAndWaitProvider: PaymentFeeAndWaitProviderProtocol {
    
    private var stqFeeWait: [Decimal: Decimal] = [1: 10, 2: 9, 3: 8, 4: 7, 5: 6, 6: 5]
    private var btcFeeWait: [Decimal: Decimal] = [10: 101, 20: 91, 30: 81, 40: 71, 50: 61, 60: 51]
    private var ethFeeWait: [Decimal: Decimal] = [11: 102, 12: 92, 13: 82, 14: 72, 15: 62, 16: 52]
    private var fiatFeeWait: [Decimal: Decimal] = [21: 103, 22: 93, 23: 83, 24: 73, 25: 63, 26: 53]
    
    private var selected = [Decimal: Decimal]()
    
    func updateSelectedForCurrency(_ currency: Currency) {
        switch currency {
        case .stq:
            selected = stqFeeWait
        case .btc:
            selected = btcFeeWait
        case .eth:
            selected = ethFeeWait
        case .fiat:
            selected = fiatFeeWait
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
    
    func getWait(fee: Decimal) -> Decimal {
        return selected[fee]!
    }

}
