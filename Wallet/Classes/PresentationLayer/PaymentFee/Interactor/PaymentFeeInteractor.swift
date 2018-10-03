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
    func getAmount() -> String {
        return sendProvider.getAmountStr()
    }
    
    func getAddress() -> String {
        let address: String
        
        switch sendProvider.opponentType {
        case .contact:
            //TODO: будем получать?
            address = "test address"
        case .address(let addr):
            address = addr
        }
        
        return address
    }
    
    func createTransaction() -> Transaction {
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
    
    func getPaymentFeeScreenData() -> PaymentFeeScreenData {
        
        let header = SendingHeaderData(amount: sendProvider.getAmountStr(),
                                       amountInTransactionCurrency: sendProvider.getAmountInTransactionCurrencyStr(),
                                       currencyImage: sendProvider.receiverCurrency.mediumImage)
        let address: String
        
        switch sendProvider.opponentType {
        case .contact:
            //TODO: будем получать?
            address = "test address"
        case .address(let addr):
            address = addr
        }
        
        let data = PaymentFeeScreenData(header: header,
                                        address: address,
                                        receiverName: sendProvider.getReceiverName(),
                                        paymentFeeValuesCount: sendProvider.getFeeWaitCount())
        
        return data
        
    }
    
    func getSubtotal() -> String {
        return sendProvider.getSubtotal()
    }
    
}
