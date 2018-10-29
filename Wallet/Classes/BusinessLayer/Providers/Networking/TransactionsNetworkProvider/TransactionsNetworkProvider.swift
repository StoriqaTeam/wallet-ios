//
//  TransactionsNetworkProvider.swift
//  Wallet
//
//  Created by Tata Gri on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsNetworkProviderProtocol {
    func getTransactions(authToken: String, userId: Int, offset: Int, limit: Int,
                         queue: DispatchQueue,
                         completion: @escaping (Result<[Transaction]>) -> Void)
}

class TransactionsNetworkProvider: NetworkLoadable, TransactionsNetworkProviderProtocol {
    func getTransactions(authToken: String, userId: Int, offset: Int, limit: Int,
                         queue: DispatchQueue,
                         completion: @escaping (Result<[Transaction]>) -> Void) {
        
        let request = API.Authorized.getTransactions(authToken: authToken, userId: userId, offset: offset, limit: limit)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let txsJson = json.array {
                    let txs = txsJson.compactMap { Transaction(json: $0) }
                    completion(.success(txs))
                } else {
                    let apiError = TransactionsNetworkProviderError(json: json)
                    completion(.failure(apiError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum TransactionsNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case unknownError
    case internalServer
    
    init(json: JSON) {
        let description = json["description"].stringValue
        
        switch description {
        case "Unauthorized": self = .unauthorized
        case "Internal server error": self = .internalServer
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .unknownError, .internalServer:
            return Constants.Errors.userFriendly
        }
    }
}
