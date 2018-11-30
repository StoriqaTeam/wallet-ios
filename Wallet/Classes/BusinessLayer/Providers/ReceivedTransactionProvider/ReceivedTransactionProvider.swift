//
//  ReceivedTransactionProvider.swift
//  Wallet
//
//  Created by Storiqa on 30/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation


protocol ReceivedTransactionProviderProtocol {
    func resolve(oldTxs: [Transaction], newTxs: [Transaction])
    func setReceivedTxsChannel(_ channel: ReceivedTxsChannel)
}


class ReceivedTransactionProvider: ReceivedTransactionProviderProtocol {
    
    private let directionResolver: TransactionDirectionResolverProtocol
    private var receivedTxsChannelOutput: ReceivedTxsChannel?
    
    init(directionResolver: TransactionDirectionResolverProtocol) {
        self.directionResolver = directionResolver
    }
    
    func setReceivedTxsChannel(_ channel: ReceivedTxsChannel) {
        guard receivedTxsChannelOutput == nil else {
            return
        }
        
        self.receivedTxsChannelOutput = channel
    }
    
    func resolve(oldTxs: [Transaction], newTxs: [Transaction]) {
        let diff = newTxs.filter { (tx) -> Bool in
            let exists = oldTxs.contains(where: { $0.id == tx.id })
            return !exists
        }
        
        let received = diff.filter { (tx) -> Bool in
            let direction = directionResolver.resolveDirection(for: tx)
            let isReceived = direction == .receive
            return isReceived
        }
        
        let stqAmount = received.filter({ $0.toCurrency == .stq }).map({ $0.toValue }).reduce(0, +)
        let ethAmount = received.filter({ $0.toCurrency == .eth }).map({ $0.toValue }).reduce(0, +)
        let btcAmount = received.filter({ $0.toCurrency == .btc }).map({ $0.toValue }).reduce(0, +)
        
        print("--- stq \(stqAmount)")
        print("--- eth \(ethAmount)")
        print("--- btc \(btcAmount)")
        
        if !stqAmount.isZero || !ethAmount.isZero || !btcAmount.isZero {
            receivedTxsChannelOutput?.send((stq: stqAmount, eth: ethAmount, btc: btcAmount))
        }
    }
}
