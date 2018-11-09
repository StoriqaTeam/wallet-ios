//
//  API+Rates.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire


extension API {
    enum Rates {
        case getRates(crypto: [String], fiat: [String])
        case getExchangeRate(authToken: String, id: String, from: Currency, to: Currency, amountCurrency: Currency, amountInMinUnits: Decimal)
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
    
    var headers: [String : String] {
        switch self {
        case .getRates:
            return [:]
        case .getExchangeRate(let authToken, _, _, _, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .getRates:
            return nil
        case .getExchangeRate(_, let id, let from, let to, let amountCurrency, let amountInMinUnits):
            return [
                    "id": id,
                    "from": from.rawValue,
                    "to": to.rawValue,
                    "amountCurrency": amountCurrency.rawValue,
                    "amount": amountInMinUnits
            ]
        }
    }
}
