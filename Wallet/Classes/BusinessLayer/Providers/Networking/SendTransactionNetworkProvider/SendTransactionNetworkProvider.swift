//
//  SendTransactionNetworkProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendTransactionNetworkProviderProtocol {
    func send(transaction: TransactionDisplayable,
              userId: String,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              completion: @escaping (Result<Transaction>) -> Void)
}

class SendTransactionNetworkProvider: NetworkLoadable, SendTransactionNetworkProviderProtocol {
    
    func send(transaction: TransactionDisplayable,
              userId: String,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              completion: @escaping (Result<Transaction>) -> Void) {
        
        let txId = transaction.transaction.id
        let userId = userId
        let fromAccount = fromAccount
        let currency = transaction.currency
        let receiverType = getReceiverType(transaction: transaction.transaction)
        
        
        let request = API.Authorized.sendTransaction(authToken: authToken,
                                                     transactionId: txId,
                                                     userId: userId,
                                                     fromAccount: fromAccount,
                                                     receiverType: receiverType,
                                                     currency: currency,
                                                     value: <#T##String#>,
                                                     fee: <#T##String#>)
    }
    
}


// MARK: - Private methods

extension SendTransactionNetworkProvider {
    
    private func getAmountInMinUnits(from transaction: Transaction) -> Decimal {
        switch transaction.currency {
        case .btc:
            return transaction.cryptoAmount
        }
        
    }
    
    private func getReceiverType(transaction: Transaction) -> ReceiverType {
        guard let account = transaction.toAccount else {
            let cryptoAddress = transaction.toAddress
            return ReceiverType.address(address: cryptoAddress)
        }
        
        let accountString = account.accountId
        return  ReceiverType.account(account: accountString)
    }
    
}
