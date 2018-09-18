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
    case apiErrors(errors: [ResponseAPIError.Message])
    case textError(message: String)
    
    static var unknownError = ResponseType.textError(message: Constants.Errors.unknown)
}
