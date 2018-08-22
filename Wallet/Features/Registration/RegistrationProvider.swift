//
//  RegistrationProvider.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol RegistrationProviderDelegate: class {
    func registrationProviderSucceed()
    func registrationProviderFailedWithMessage(_ message: String)
    func registrationProviderFailedWithApiErrors(_ errors: [ResponseAPIError.Message])
}

class RegistrationProvider {
    static let shared = RegistrationProvider()
    var requestSender: AbstractRequestSender
    weak var delegate: RegistrationProviderDelegate?
    
    private init() {
        requestSender = RequestSender()
        requestSender.delegate = self
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        let request = RegistrationRequest(firstName: firstName, lastName: lastName, email: email, password: password)
        
        requestSender.send(request)
    }
}

extension RegistrationProvider: RequestSenderDelegate {
    func requestSucceed(_ request: Request, data: [String : AnyObject]) {
        if let token = data[request.name]?["token"] as? String {
            UserInfo.shared.token = token
        }
        delegate?.registrationProviderSucceed()
    }
    
    func requestFailed(_ request: Request, apiErrors: [ResponseAPIError.Message]) {
        delegate?.registrationProviderFailedWithApiErrors(apiErrors)
    }
    
    func requestFailed(_ request: Request, message: String) {
        delegate?.registrationProviderFailedWithMessage(message)
    }
}
