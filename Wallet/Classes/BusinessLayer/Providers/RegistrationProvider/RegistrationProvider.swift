//
//  RegistrationProvider.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol RegistrationProviderProtocol {
    func register(firstName: String, lastName: String, email: String, password: String)
}

class RegistrationProvider: RegistrationProviderProtocol {
    private let requestSender: AbstractRequestSender = RequestSender()
    weak var delegate: ProviderDelegate?
    
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
                delegate.providerSucceed()
                
            case .textError(let message):
                delegate.providerFailedWithMessage(message)
                
            case .apiErrors(let apiErrors):
                delegate.providerFailedWithApiErrors(apiErrors)
            }
        }
    }
}
