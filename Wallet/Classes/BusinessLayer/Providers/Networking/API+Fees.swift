//
//  API+Fees.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire


extension API {
    enum Fees {
        case getFees(authToken: String, fromCurrency: Currency, toCurrency: Currency)
    }
}


extension API.Fees: APIMethodProtocol {
    
    var method: HTTPMethod {
        switch self {
        case .getFees:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getFees:
            return "\(Constants.Network.baseUrl)/fees"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getFees(let authToken, _, _):
            return [
                "Authorization": "Bearer \(authToken)"
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .getFees(_, let fromCurrency, let toCurrency):
            return [
                "fromCurrency": fromCurrency.ISO.lowercased(),
                "toCurrency": toCurrency.ISO.lowercased()
            ]
        }
    }
}
