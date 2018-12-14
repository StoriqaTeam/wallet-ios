//
//  InitialNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class InitialNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        switch code {
        case 200: return DefaultNetworkProviderError.parseJsonError
        case 400: return DefaultNetworkProviderError.badRequest
        case 401: return DefaultNetworkProviderError.unauthorized
        case 500: return DefaultNetworkProviderError.internalServer
        default: return next!.parse(code: code, json: json)
        }
    }
}

enum DefaultNetworkProviderError: LocalizedError, Error {
    case badRequest
    case unauthorized
    case internalServer
    case parseJsonError
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .badRequest:
            return "Bad request"
        case .internalServer:
            return "Internal server error"
        case .parseJsonError:
            return "Parse response error"
        }
    }
}
