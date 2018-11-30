//
//  AccountsNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsNetworkProviderProtocol {
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     signHeader: SignHeader,
                     completion: @escaping (Result<[Account]>) -> Void)
}

class AccountsNetworkProvider: NetworkLoadable, AccountsNetworkProviderProtocol {
    
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     signHeader: SignHeader,
                     completion: @escaping (Result<[Account]>) -> Void) {
        
        let request = API.Authorized.getAccounts(authToken: authToken, userId: userId, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response.value)
                
                guard let accountsJson = json.array else {
                    let apiError = AccountsNetworkProviderError(code: response.responseStatusCode)
                    completion(.failure(apiError))
                    return
                }
                
                guard !accountsJson.isEmpty else {
                    let apiError = AccountsNetworkProviderError.emptyAccountList
                    completion(.failure(apiError))
                    return
                }
                
                let accounts = accountsJson.compactMap { Account(json: $0) }
                
                guard accounts.count == accountsJson.count else {
                    let apiError = AccountsNetworkProviderError.parseJsonError
                    completion(.failure(apiError))
                    return
                }
                
                completion(.success(accounts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

enum AccountsNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case unknownError
    case internalServer
    case emptyAccountList
    case parseJsonError
    
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
        case .unknownError, .internalServer:
            return Constants.Errors.userFriendly
        case .parseJsonError:
            return "JSON parse error"
        case .emptyAccountList:
            return "No accounts received. Please, try again later."
        }
    }
}
