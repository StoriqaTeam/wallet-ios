//
//  PaymentFeeInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PaymentFeeInteractor {
    weak var output: PaymentFeeInteractorOutput!
    
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let sendProvider: SendTransactionProviderProtocol
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol) {
        self.sendTransactionBuilder = sendTransactionBuilder
        self.sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - PaymentFeeInteractorInput

extension PaymentFeeInteractor: PaymentFeeInteractorInput {
    
    func getAddress() -> String {
        let address: String
        
        switch sendProvider.opponentType {
        case .contact:
            //TODO: будем получать?
            address = "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD"
        case .address(let addr):
            address = addr
        case .txAccount:
            fatalError("TransactionAccount is impossible on send")
        }
        
        return address
    }
    
    func createTransaction() -> Transaction? {
        let transaction = sendProvider.createTransaction()
        return transaction
    }
    
    func isEnoughFunds() -> Bool {
        return sendProvider.isEnoughFunds()
    }
    
    func setPaymentFee(index: Int) {
        sendTransactionBuilder.setPaymentFee(index: index)
    }
    
    func getFeeAndWait() -> (fee: String, wait: String) {
        return sendProvider.getFeeAndWait()
    }
    
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func getSubtotal() -> Decimal {
        return sendProvider.getSubtotal()
    }
    
    func getAmount() -> Decimal {
        return sendProvider.amount
    }
    
    func getConvertedAmount() -> Decimal {
        return sendProvider.getConvertedAmount()
    }
    
    func getReceiverCurrency() -> Currency {
        return sendProvider.receiverCurrency
    }
    
    func getSelectedAccount() -> Account {
        return sendProvider.selectedAccount
    }
    
    func getOpponent() -> OpponentType {
        return sendProvider.opponentType
    }
    
    func getFeeWaitCount() -> Int {
        return sendProvider.getFeeWaitCount()
    }
    
    func clearBuilder() {
        sendTransactionBuilder.clear()
    }
    
}
