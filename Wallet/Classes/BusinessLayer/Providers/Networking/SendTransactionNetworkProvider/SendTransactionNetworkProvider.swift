//
//  SendTransactionNetworkProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendTransactionNetworkProviderProtocol {
    func send(transaction: Transaction,
              userId: Int,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              completion: @escaping (Result<Transaction>) -> Void)
}

class SendTransactionNetworkProvider: NetworkLoadable, SendTransactionNetworkProviderProtocol {
    
    func send(transaction: Transaction,
              userId: Int,
              fromAccount: String,
              authToken: String,
              queue: DispatchQueue,
              completion: @escaping (Result<Transaction>) -> Void) {
        
        let txId = transaction.id
        let userId = userId
        let fromAccount = fromAccount
        let currency = transaction.currency
        let receiverType = getReceiverType(transaction: transaction)
        let value = transaction.cryptoAmount.string
        
        // TODO: - Now fee is fix and equals zero because of server!!!
        // let fee = transaction.fee.string
        let feeString = "0"
        
        let request = API.Authorized.sendTransaction(authToken: authToken,
                                                     transactionId: txId,
                                                     userId: userId,
                                                     fromAccount: fromAccount,
                                                     receiverType: receiverType,
                                                     currency: currency,
                                                     value: value,
                                                     fee: feeString)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                if code == 200 {
                    guard let transaction = Transaction(json: json) else {
                        let apiError = SendTransactionNetworkProviderError(code: 500)
                        completion(.failure(apiError))
                        return
                    }
                    completion(.success(transaction))
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
            let cryptoAddress = transaction.toAddress.lowercased()
            
            switch transaction.currency {
            case .eth, .stq:
                if cryptoAddress.count == 42 {
                    let address = String(cryptoAddress.suffix(40)).lowercased()
                    return ReceiverType.address(address: address)
                }
                
                return ReceiverType.address(address: cryptoAddress)
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
        }
    }
}
