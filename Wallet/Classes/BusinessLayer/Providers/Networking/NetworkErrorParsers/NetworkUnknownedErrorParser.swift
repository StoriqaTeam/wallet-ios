//
//  NetworkUnknownedErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class NetworkUnknownedErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        return NetworkUnknownedError.unknowned
    }
}


enum NetworkUnknownedError: LocalizedError, Error {
    case unknowned
    
    var errorDescription: String? {
        return Constants.Errors.userFriendly
    }
}
