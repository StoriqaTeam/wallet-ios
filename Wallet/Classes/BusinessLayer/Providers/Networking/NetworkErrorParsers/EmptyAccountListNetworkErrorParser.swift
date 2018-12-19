//
//  EmptyAccountListNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 13/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class EmptyAccountListNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        if code == 200 {
            return EmptyAccountListNetworkError.emptyAccountList
        }
        
        return next!.parse(code: code, json: json)
    }
}


enum EmptyAccountListNetworkError: LocalizedError, Error {
    case emptyAccountList
    
    var errorDescription: String? {
        return "No accounts received. Please, try again later."
    }
}
