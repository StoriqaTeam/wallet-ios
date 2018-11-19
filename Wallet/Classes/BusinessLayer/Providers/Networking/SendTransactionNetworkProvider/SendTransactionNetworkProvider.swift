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
        let value = transaction.toValue.string
        let receiverType = getReceiverType(transaction: transaction)
        
        // TODO: - Now fee is fix and equals zero because of server!!!
        // let fee = transaction.fee.string
        let feeString = "0"
        
        // TODO: - exchangeId, exchangeRate
        let request = API.Authorized.sendTransaction(authToken: authToken,
                                                     transactionId: txId,
                                                     userId: userId,
                                                     fromAccount: fromAccount,
                                                     receiverType: receiverType,
                                                     toCurrency: toCurrency,
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
                    let apiError = SendTransactionNetworkProviderError(code: code)
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


enum SendTransactionNetworkProviderError: LocalizedError, Error {
    case internalServer
    case unauthorized
    case unknownError
    case failToParseJson
    
    init(code: Int) {
        switch code {
        case 401:
            self = .unauthorized
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
        case .unknownError:
            return Constants.Errors.userFriendly
        case .failToParseJson:
            return "Failed to parse JSON"
        }
    }
}
