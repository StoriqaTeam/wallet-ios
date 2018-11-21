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
        case getFees(authToken: String, currency: Currency, accountAddress: String, signHeader: SignHeader)
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
        case .getFees(let authToken, _, _, let signHeader):
            return [
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .getFees(_, let currency, let accountAddress, _):
            return [
                "currency": currency.ISO.lowercased(),
                "accountAddress": accountAddress
            ]
        }
    }
}
