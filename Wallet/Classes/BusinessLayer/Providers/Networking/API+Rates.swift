//
//  API+Rates.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire


extension API {
    enum Rates {
        case getRates(crypto: [String], fiat: [String])
    }
}


extension API.Rates: APIMethodProtocol {
    
    var method: HTTPMethod {
        switch self {
        case .getRates:
            return .get
        }
    }
    
    
    var path: String {
        switch self {
        case .getRates(let crypto, let fiat):
            let fsyms = crypto.joined(separator: ",")
            let tsyms = fiat.joined(separator: ",")
            return "\(Constants.Network.Rates.ratesBaseUrl)fsyms=\(fsyms)&tsyms=\(tsyms)"
        }
    }
}
