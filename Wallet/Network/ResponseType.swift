//
//  ResponseType.swift
//  Wallet
//
//  Created by user on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum ResponseType {
    case success(data: [String: AnyObject])
    case apiErrors(errors: [ResponseError])
    case textError(message: String)
    
    static var unknownError = ResponseType.textError(message: "Unknown error")
    
    func parseResponseErrors() -> (api: [ResponseAPIError.Message], default: String)? {
        
        switch self {
        case .apiErrors(errors: let errors):
            let apiErrors = errors.flatMap({ (error) -> [ResponseAPIError.Message] in
                return (error as? ResponseAPIError)?.messages ?? []
            })
            
            let defaultErrors = errors.compactMap({ (error) -> String? in
                return (error as? ResponseDefaultError)?.details
            }).reduce("", {
                return $0 + "\n" + $1
            })
            
            return (apiErrors, defaultErrors.trim())
            
        default:
            return nil
        }
        
        
    }
}
