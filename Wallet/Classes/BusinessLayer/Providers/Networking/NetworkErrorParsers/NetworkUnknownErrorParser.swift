//
//  NetworkUnknownErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class NetworkUnknownErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        return NetworkUnknownError()
    }
}


struct NetworkUnknownError: LocalizedError, Error {
    var errorDescription: String? {
        return Constants.Errors.userFriendly
    }
}
