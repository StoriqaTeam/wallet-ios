//
//  ConstantRateFiatConverter.swift
//  Wallet
//
//  Created by Storiqa on 29/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConstantRateFiatConverterProtocol {
    func convert(amount: Decimal) -> Decimal
}


class ConstantRateFiatConverter: ConstantRateFiatConverterProtocol {
    private let rate: Rate
    
    init(rate: Rate) {
        self.rate = rate
    }
    
    func convert(amount: Decimal) -> Decimal {
        return amount * rate.value
    }
}
