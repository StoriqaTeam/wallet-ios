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
    
    private let sendProvider: SendTransactionBuilderProtocol
    
    init(sendProvider: SendTransactionBuilderProtocol) {
        self.sendProvider = sendProvider
    }

}


// MARK: - PaymentFeeInteractorInput

extension PaymentFeeInteractor: PaymentFeeInteractorInput {
    func setPaymentFee(index: Int) {
        sendProvider.setPaymentFee(index: index)
    }
    
    func getFeeAndWait() -> (fee: String, wait: String) {
        return sendProvider.getFeeAndWait()
    }
    
    func getSendTransactionBuilder() -> SendTransactionBuilderProtocol {
        return sendProvider
    }
    
    func getPaymentFeeScreenData() -> PaymentFeeScreenData {
        
        let header = SendingHeaderData(amount: sendProvider.getAmountStr(),
                                 amountInTransactionCurrency: sendProvider.getAmountInTransactionCurrencyStr(),
                                 currencyImage: sendProvider.receiverCurrency.image)
        let address: String
        
        switch sendProvider.opponentType! {
        case .contact:
            //TODO: будем получать?
            address = "test address"
        case .address(let addr):
            address = addr
        }
        
        return PaymentFeeScreenData(header: header,
                                    address: address,
                                    receiverName: sendProvider.getReceiverName(),
                                    paymentFeeValuesCount: sendProvider.getFeeWaitCount())
        
    }

    func getSubtotal() -> String {
        return sendProvider.getSubtotal()
    }
    
}
