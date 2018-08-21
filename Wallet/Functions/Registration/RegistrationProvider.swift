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
    private let requestSender = RequestSender()
    weak var delegate: RegistrationProviderDelegate?
    
    private init() {}
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        let request = RegistrationRequest(firstName: firstName, lastName: lastName, email: email, password: password)
        
        requestSender.send(request) { [weak self] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let data):
                //TODO:
                
                strongSelf.delegate?.registrationProviderSucceed()
                
            case .apiErrors:
                
                if let errors = response.parseResponseErrors() {
                    if !errors.api.isEmpty {
                        strongSelf.delegate?.registrationProviderFailedWithApiErrors(errors.api)
                    }
                    if !errors.default.isEmpty {
                        strongSelf.delegate?.registrationProviderFailedWithMessage(errors.default)
                    }
                }
                
            case .textError(let message):
                strongSelf.delegate?.registrationProviderFailedWithMessage(message)
            }
        }
    }
}
