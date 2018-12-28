//
//  ShortPollingTimerFactory.swift
//  Wallet
//
//  Created by Storiqa on 28/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ShortPollingTimerFactoryProtocol {
    func createShortPollingTimer(timeout: Int) -> ShortPollingTimerProtocol
    func createDepositShortPollingTimer(timeout: Int) -> DepositShortPollingTimerProtocol
}


class ShortPollingTimerFactory: ShortPollingTimerFactoryProtocol {
    
    func createShortPollingTimer(timeout: Int) -> ShortPollingTimerProtocol {
        return ShortPollingTimer(timeout: timeout)
    }
    
    func createDepositShortPollingTimer(timeout: Int) -> DepositShortPollingTimerProtocol {
        return DepositShortPollingTimer(timeout: timeout)
    }
    
}
