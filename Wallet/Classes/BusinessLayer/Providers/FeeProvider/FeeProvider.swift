//
//  FeeProvider.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol FeeProviderProtocol {
    func updateFees(fees: [EstimatedFee]?)
    func getValuesCount() -> Int
    func getIndex(fee: Decimal) -> Int
    func getFee(index: Int) -> Decimal?
    func getWait(fee: Decimal) -> String
}

class FeeProvider: FeeProviderProtocol {
    
    private let medianWaitFormatter: MedianWaitFormatterProtocol
    private var fees: [EstimatedFee]?
    
    init(medianWaitFormatter: MedianWaitFormatterProtocol) {
        self.medianWaitFormatter = medianWaitFormatter
    }
    
    func updateFees(fees: [EstimatedFee]?) {
        guard let fees = fees else {
            self.fees = nil
            return
        }
        
        let rounded = roundedValues(fees)
        
        let sorted = rounded.sorted(by: {
            $0.value < $1.value
        })
        
        self.fees = sorted
    }
    
    func getValuesCount() -> Int {
        return fees?.count ?? 0
    }
    
    func getIndex(fee: Decimal) -> Int {
        let index = fees?.firstIndex {
            $0.value == fee
        }!
        return index ?? 0
    }
    
    func getFee(index: Int) -> Decimal? {
        guard (fees?.count ?? 0) > index else {
            return nil
        }
        
        return fees?[index].value
    }
    
    func getWait(fee: Decimal) -> String {
        guard let wait = fees?.first(where: { $0.value == fee })!.estimatedTime else {
            return ""
        }
        
        let formatted = medianWaitFormatter.stringValue(from: wait)
        return formatted
    }
}


// Private methods

extension FeeProvider {
    func roundedValues(_ fees: [EstimatedFee]) -> [EstimatedFee] {
        
        let roundedFees = fees.map { (fee) -> EstimatedFee in
            switch fee.currency {
            case .stq:
                let newValue = Decimal(round((fee.value / pow(10, 18)).double)) * pow(10, 18)
                let roundedFee = EstimatedFee(currency: fee.currency, value: newValue, estimatedTime: fee.estimatedTime)
                return roundedFee
                
            case .eth:
                let newValue = Decimal(round((fee.value / pow(10, 12)).double)) * pow(10, 12)
                let roundedFee = EstimatedFee(currency: fee.currency, value: newValue, estimatedTime: fee.estimatedTime)
                return roundedFee
                
            default:
                return fee
            }
        }
        
        return roundedFees
    }
}
