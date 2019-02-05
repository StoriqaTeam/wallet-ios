//
//  API+Rates.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import Alamofire


extension API {
    enum Rates {
        case getRates(crypto: [String], fiat: [String])
        case getExchangeRate(authToken: String,
            id: String,
            from: Currency,
            to: Currency,
            amountCurrency: Currency,
            amountInMinUnits: Decimal,
            signHeader: SignHeader)
    }
}


extension API.Rates: APIMethodProtocol {
    
    var method: HTTPMethod {
        switch self {
        case .getRates:
            return .get
        case .getExchangeRate:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getRates(let crypto, let fiat):
            let fsyms = crypto.joined(separator: ",")
            let tsyms = fiat.joined(separator: ",")
            return "\(Constants.Network.ratesBaseUrl)fsyms=\(fsyms)&tsyms=\(tsyms)"
        case .getExchangeRate:
            return "\(Constants.Network.baseUrl)/rate"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getRates:
            return [:]
        case .getExchangeRate(let authToken, _, _, _, _, _, let signHeader):
            return [
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
        case .getRates:
            return nil
        case .getExchangeRate(_, let id, let from, let to, let amountCurrency, let amountInMinUnits, _):
            return [
                "id": id,
                "from": from.ISO.lowercased(),
                "to": to.ISO.lowercased(),
                "amountCurrency": amountCurrency.ISO.lowercased(),
                "amount": amountInMinUnits
            ]
        }
    }
}
