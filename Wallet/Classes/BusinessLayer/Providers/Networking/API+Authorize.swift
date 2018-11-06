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
        case user(authToken: String)
        case getAccounts(authToken: String, userId: Int)
        case getTransactions(authToken: String, userId: Int, offset: Int, limit: Int)
        case sendTransaction(authToken: String,
            transactionId: String,
            userId: Int,
            fromAccount: String,
            receiverType: ReceiverType,
            currency: Currency,
            value: String,
            fee: String)
        case changePassword(authToken: String, currentPassword: String, newPassword: String)
        case createAccount(authToken: String, userId: Int, id: String, currency: Currency, name: String)
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
             .changePassword,
             .createAccount:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(Constants.Network.baseUrl)/users/me"
        case .getAccounts(_, let userId):
            // FIXME: разобраться с offset и limit!!!
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts?offset=0&limit=50"
        case .getTransactions(_, let userId, let offset, let limit):
            return "\(Constants.Network.baseUrl)/users/\(userId)/transactions?offset=\(offset)&limit=\(limit)"
        case .sendTransaction:
            return "\(Constants.Network.baseUrl)/transactions"
        case .changePassword:
            return "\(Constants.Network.baseUrl)/users/change_password"
        case .createAccount(_, let userId, _, _, _):
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .user(let authToken):
            return [
                "Authorization": "Bearer \(authToken)"
            ]
        case .getAccounts(let authToken, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .getTransactions(let authToken, _, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .sendTransaction(let authToken, _, _, _, _, _, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .changePassword(let authToken, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .createAccount(let authToken, _, _, _, _):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
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
        case .sendTransaction(_, let transactionId, let userId, let fromAccount, let receiverType, let currency, let value, let fee):
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
            
            return [
                    "id": transactionId,
                    "userId": userId,
                    "from": fromAccount,
                    "to": receiverAddress,
                    "toType": type,
                    "toCurrency": currency.ISO.lowercased(),
                    "value": value,
                    "fee": fee
            ]
        case .changePassword(_, let currentPassword, let newPassword):
            return [
                "newPassword": newPassword,
                "oldPassword": currentPassword
            ]
        case .createAccount(_, _, let id, let currency, let name):
            return [
                "id": id,
                "currency": currency.ISO.lowercased(),
                "name": name
            ]
        }
    }
}
