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
    var requestSender: AbstractRequestSender = RequestSender()
    weak var delegate: RegistrationProviderDelegate?
    
    private init() { }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        let request = RegistrationRequest(firstName: firstName, lastName: lastName, email: email, password: password)
        
        requestSender.sendGrqphQLRequest(request) {[weak self] (response) in
            guard let strongSelf = self else {
                log.warn("self is nil")
                return
            }
            
            guard let delegate = strongSelf.delegate else {
                log.warn("delegate is nil")
                return
            }
            
            switch response {
            case .success(let data):
                log.debug(data)
                
                //TODO: какие данные получать?
                delegate.registrationProviderSucceed()
                
            case .textError(let message):
                delegate.registrationProviderFailedWithMessage(message)
                
            case .apiErrors(let apiErrors):
                delegate.registrationProviderFailedWithApiErrors(apiErrors)
            }
        }
    }
}
