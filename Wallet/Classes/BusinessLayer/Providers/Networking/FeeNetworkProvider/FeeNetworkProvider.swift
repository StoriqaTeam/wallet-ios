//
//  FeeNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol FeeNetworkProviderProtocol {
    func getFees(authToken: String,
                 currency: Currency,
                 accountAddress: String,
                 signHeader: SignHeader,
                 queue: DispatchQueue,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void)
}

class FeeNetworkProvider: NetworkLoadable, FeeNetworkProviderProtocol {
    func getFees(authToken: String,
                 currency: Currency,
                 accountAddress: String,
                 signHeader: SignHeader,
                 queue: DispatchQueue,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void) {
        let request = API.Fees.getFees(authToken: authToken, currency: currency, accountAddress: accountAddress, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else {
                    let error = FeeNetworkProviderError(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                guard let feesData = json["fees"].array,
                    !feesData.isEmpty else {
                    let error = FeeNetworkProviderError.parseJsonError
                    completion(.failure(error))
                    return
                }
                
                let fees = feesData.compactMap { EstimatedFee(json: $0, currency: currency) }
                
                guard !fees.isEmpty else {
                    let error = FeeNetworkProviderError.parseJsonError
                    completion(.failure(error))
                    return
                }
                
                completion(.success(fees))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum FeeNetworkProviderError: LocalizedError, Error {
    case unknownError
    case internalServer
    case parseJsonError
    case wrongCurrency(message: String)
    
    init(code: Int, json: JSON) {
        switch code {
        case 422:
            if let accountErrors = json["account"].array,
                accountErrors.contains(where: { $0["code"] == "currency" }) {
                // FIXME: error message
                self = .wrongCurrency(message: "Account currency doesn't match address currency")
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
        return Constants.Errors.userFriendly
    }
}
