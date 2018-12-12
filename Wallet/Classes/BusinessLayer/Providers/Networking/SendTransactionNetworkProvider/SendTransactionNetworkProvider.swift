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
                                                     signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                if code == 200 {
                    guard let txn = Transaction(json: json) else {
                        log.error("Failed to parse sent transaction json")
                        let apiError = SendTransactionNetworkProviderError.failToParseJson
                        completion(.failure(apiError))
                        return
                    }
                    completion(.success(txn))
                } else {
                    let apiError = SendTransactionNetworkProviderError(code: code, json: json, currency: valueCurrency)
                    completion(.failure(apiError))
                    return
                }
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
                                                     signHeader: signHeader)
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                if code == 200 {
                    guard let txn = Transaction(json: json) else {
                        log.error("Failed to parse sent transaction json")
                        let apiError = SendTransactionNetworkProviderError.failToParseJson
                        completion(.failure(apiError))
                        return
                    }
                    completion(.success(txn))
                } else {
                    let apiError = SendTransactionNetworkProviderError(code: code, json: json, currency: valueCurrency)
                    completion(.failure(apiError))
                    return
                }
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

// SendNetworkErrorParser

enum SendTransactionNetworkProviderError: LocalizedError, Error {
    case internalServer
    case unauthorized
    case unknownError
    case failToParseJson
    case orderExpired
    case notEnoughBalance
    case exceededDayLimit(limit: String, currency: Currency)
    case amountOutOfBounds(min: String, max: String, currency: Currency)
    
    init(code: Int, json: JSON, currency: Currency) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            if let deviceErrors = json["actual_amount"].array,
                let existsError = deviceErrors.first(where: { $0["code"] == "limit" }),
                let params = existsError["params"].dictionary,
                let min = params["min"]?.string,
                let max = params["max"]?.string {
                self = .amountOutOfBounds(min: min, max: max, currency: currency)
            } else if let exchangeRate = json["exchange_rate"].array,
                exchangeRate.contains(where: { $0["code"] == "expired" }) {
                self = .orderExpired
            } else if let accountErrors = json["value"].array,
                accountErrors.contains(where: { $0["code"] == "not_enough_balance" }) {
                self = .notEnoughBalance
            } else if let accountErrors = json["value"].array,
                let limitError = accountErrors.first(where: { $0["code"] == "exceeded_daily_limit" }),
                let params = limitError["params"].dictionary,
                let limit = params["limit"]?.string {
                self = .exceededDayLimit(limit: limit, currency: currency)
            } else {
                self = .unknownError
            }
        case 500:
            self = .internalServer
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .internalServer:
            return "Internal server error"
        case .unknownError,
             .amountOutOfBounds,
             .exceededDayLimit:
             return Constants.Errors.userFriendly
        case .failToParseJson:
            return "Failed to parse JSON"
        case .orderExpired:
            return "Current exchange order did expire"
        case .notEnoughBalance:
            return "Account balance is not enough"
        }
    }
}
