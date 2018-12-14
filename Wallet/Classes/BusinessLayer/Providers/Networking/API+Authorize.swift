//
//  API+Authorize.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name


import Foundation
import Alamofire


enum ReceiverType {
    case address(address: String)
    case account(account: String)
}


extension API {
    enum Authorized {
        case user(authToken: String, signHeader: SignHeader)
        case getAccounts(authToken: String, userId: Int, signHeader: SignHeader)
        case getTransactions(authToken: String, userId: Int, offset: Int, limit: Int, signHeader: SignHeader)
        case sendTransaction(authToken: String,
            transactionId: String,
            userId: Int,
            fromAccount: String,
            receiverType: ReceiverType,
            toCurrency: Currency,
            value: String,
            valueCurrency: Currency,
            fee: String,
            exchangeId: String?,
            exchangeRate: Decimal?,
            signHeader: SignHeader)
        case createAccount(authToken: String, userId: Int, id: String, currency: Currency, name: String, signHeader: SignHeader)
        case refreshAuthToken(authToken: String, signHeader: SignHeader)
    }
}

extension API.Authorized: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .user,
             .getAccounts,
             .getTransactions:
            return .get
        case .sendTransaction,
             .createAccount,
             .refreshAuthToken:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(Constants.Network.baseUrl)/users/me"
        case .getAccounts(_, let userId, _):
            // FIXME: разобраться с offset и limit!!!
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts?offset=0&limit=50"
        case .getTransactions(_, let userId, let offset, let limit, _):
            return "\(Constants.Network.baseUrl)/users/\(userId)/transactions?offset=\(offset)&limit=\(limit)"
        case .sendTransaction:
            return "\(Constants.Network.baseUrl)/transactions"
        case .createAccount(_, let userId, _, _, _, _):
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts"
        case .refreshAuthToken:
            return "\(Constants.Network.baseUrl)/sessions/refresh"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .user(let authToken, let signHeader):
            return [
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .getAccounts(let authToken, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .getTransactions(let authToken, _, _, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .sendTransaction(let authToken, _, _, _, _, _, _, _, _, _, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .createAccount(let authToken, _, _, _, _, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .refreshAuthToken(let authToken, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .getAccounts:
            return nil
        case .user:
            return nil
        case .getTransactions:
            return nil
        case .sendTransaction(_,
                              let transactionId,
                              let userId,
                              let fromAccount,
                              let receiverType,
                              let toCurrency,
                              let value,
                              let valueCurrency,
                              let fee,
                              let exchangeId,
                              let exchangeRate,
                              _):
            let receiverAddress: String
            let type: String
            
            switch receiverType {
            case .address(address: let address):
                receiverAddress = address
                type = "address"
            case .account(account: let account):
                receiverAddress = account
                type = "account"
            }
            
            var params: [String: Any] = [
                "id": transactionId,
                "userId": userId,
                "from": fromAccount,
                "to": receiverAddress,
                "toType": type,
                "toCurrency": toCurrency.ISO.lowercased(),
                "value": value,
                "valueCurrency": valueCurrency.ISO.lowercased(),
                "fee": fee
                ]
            
            if let exchangeId = exchangeId,
                let exchangeRate = exchangeRate {
                params["exchangeId"] = exchangeId
                params["exchangeRate"] = exchangeRate
            }
            
            return params
        case .createAccount(_, _, let id, let currency, let name, _):
            return [
                "id": id,
                "currency": currency.ISO.lowercased(),
                "name": name
            ]
        case .refreshAuthToken:
            return nil
        }
    }
}
