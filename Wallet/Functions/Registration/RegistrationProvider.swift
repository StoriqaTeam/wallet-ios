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
    func registrationProviderFailedWithErrors(_ errors: [ResponseError])
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
                
            case .apiErrors(let errors):
                strongSelf.delegate?.registrationProviderFailedWithErrors(errors)
                
            case .textError(let message):
                strongSelf.delegate?.registrationProviderFailedWithMessage(message)
            }
        }
    }
}
