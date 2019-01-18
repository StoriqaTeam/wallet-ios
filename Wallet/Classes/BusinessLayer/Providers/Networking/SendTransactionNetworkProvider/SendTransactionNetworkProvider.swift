//
//  SendTransactionNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendTransactionNetworkProviderProtocol {
    func send(transaction: Transaction,
              userId: Int,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              signHeader: SignHeader,
              completion: @escaping (Result<Transaction>) -> Void)
    
    func sendExchange(transaction: Transaction,
                      userId: Int,
                      fromAccount: String,
                      authToken: String,
                      queue: DispatchQueue,
                      signHeader: SignHeader,
                      exchangeId: String,
                      exchangeRate: Decimal,
                      completion: @escaping (Result<Transaction>) -> Void)
}

class SendTransactionNetworkProvider: NetworkLoadable, SendTransactionNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createSendErrorResolver()
    }
    
    func send(transaction: Transaction,
              userId: Int,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              signHeader: SignHeader,
              completion: @escaping (Result<Transaction>) -> Void) {
        
        let txId = transaction.id
        let toCurrency = transaction.toCurrency
        let valueCurrency = toCurrency
        let value = transaction.toValue.string
        let receiverType = getReceiverType(transaction: transaction)
        let feeString = transaction.fee.string
        
        let request = API.Authorized.sendTransaction(authToken: authToken,
                                                     transactionId: txId,
                                                     userId: userId,
                                                     fromAccount: fromAccount,
                                                     receiverType: receiverType,
                                                     toCurrency: valueCurrency,
                                                     value: value,
                                                     valueCurrency: toCurrency,
                                                     fee: feeString,
                                                     exchangeId: nil,
                                                     exchangeRate: nil,
                                                     fiatValue: transaction.fiatValue,
                                                     fiatCurrency: transaction.fiatCurrency,
                                                     signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let txn = Transaction(json: json) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(txn))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendExchange(transaction: Transaction,
                      userId: Int,
                      fromAccount: String,
                      authToken: String,
                      queue: DispatchQueue,
                      signHeader: SignHeader,
                      exchangeId: String,
                      exchangeRate: Decimal,
                      completion: @escaping (Result<Transaction>) -> Void) {
        
        let txId = transaction.id
        let toCurrency = transaction.toCurrency
        let valueCurrency = toCurrency
        let value = transaction.toValue.string
        let receiverType = getReceiverType(transaction: transaction)
        let feeString = transaction.fee.string
        
        let request = API.Authorized.sendTransaction(authToken: authToken,
                                                     transactionId: txId,
                                                     userId: userId,
                                                     fromAccount: fromAccount,
                                                     receiverType: receiverType,
                                                     toCurrency: toCurrency,
                                                     value: value,
                                                     valueCurrency: valueCurrency,
                                                     fee: feeString,
                                                     exchangeId: exchangeId,
                                                     exchangeRate: exchangeRate,
                                                     fiatValue: nil,
                                                     fiatCurrency: nil,
                                                     signHeader: signHeader)
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let txn = Transaction(json: json) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(txn))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - Private methods

extension SendTransactionNetworkProvider {
    
    private func getReceiverType(transaction: Transaction) -> ReceiverType {
        guard let account = transaction.toAccount else {
            let cryptoAddress = transaction.toAddress
            
            switch transaction.toCurrency {
            case .eth, .stq:
                if cryptoAddress.count == 42 {
                    let address = String(cryptoAddress.suffix(40)).lowercased()
                    return ReceiverType.address(address: address)
                }
                
                return ReceiverType.address(address: cryptoAddress.lowercased())
            default:
                return ReceiverType.address(address: cryptoAddress)
                
            }
        }
        
        let accountString = account.accountId
        return  ReceiverType.account(account: accountString)
    }
}
