//
//  FeeProvider.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol FeeProviderProtocol {
    func updateSelected(fromCurrency: Currency, toCurrency: Currency)
    func getValuesCount() -> Int
    func getIndex(fee: Decimal) -> Int
    func getFee(index: Int) -> Decimal?
    func getWait(fee: Decimal) -> String
    
    func setFeeUpdaterChannel(_ channel: FeeUpdateChannel)
}

class FeeProvider: FeeProviderProtocol {
    
    private let feeDataStoreService: FeeDataStoreServiceProtocol
    private let medianWaitFormatter: MedianWaitFormatterProtocol
    private var feeUpadateChannelOutput: FeeUpdateChannel?
    private var selectedFees = [FeeAndWait]()
    
    init(feeDataStoreService: FeeDataStoreServiceProtocol,
         medianWaitFormatter: MedianWaitFormatterProtocol) {
        self.feeDataStoreService = feeDataStoreService
        self.medianWaitFormatter = medianWaitFormatter
    }
    
    func setFeeUpdaterChannel(_ channel: FeeUpdateChannel) {
        guard feeUpadateChannelOutput == nil else {
            return
        }
        
        self.feeUpadateChannelOutput = channel
        
        feeDataStoreService.observe { [weak self] (fees) in
            self?.feeUpadateChannelOutput?.send(fees)
        }
    }
    
    func updateSelected(fromCurrency: Currency, toCurrency: Currency) {
        
        // FIXME: delete this
        
        selectedFees = [FeeAndWait(value: 0, estimatedTime: 0)]
        
        // -----------------
        
//        let fees = feeDataStoreService.getFees()
//        let selected = fees.first {
//            $0.fromCurrency == fromCurrency && $0.toCurrency == toCurrency
//        }
//        let sorted = selected?.fees.sorted(by: {
//            $0.value < $1.value
//        })
//
//        selectedFees = sorted ?? []
    }
    
    func getValuesCount() -> Int {
        return selectedFees.count
    }
    
    func getIndex(fee: Decimal) -> Int {
        let index = selectedFees.firstIndex {
            $0.value == fee
        }!
        return index
    }
    
    func getFee(index: Int) -> Decimal? {
        guard selectedFees.count > index else {
            return nil
        }
        
        return selectedFees[index].value
    }
    
    func getWait(fee: Decimal) -> String {
        let wait = selectedFees.first(where: {
            $0.value == fee
        })!.estimatedTime
        let formatted = medianWaitFormatter.stringValue(from: wait)
        return formatted
    }
}
