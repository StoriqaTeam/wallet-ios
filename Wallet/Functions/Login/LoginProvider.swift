//
//  LoginProvider.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol LoginProviderDelegate: class {
    func loginProviderSucceed()
    func loginProviderFailedWithMessage(_ message: String)
    func loginProviderFailedWithErrors(_ errors: [ResponseError])
}

class LoginProvider {
    static let shared = LoginProvider()
    private let requestSender = RequestSender()
    weak var delegate: LoginProviderDelegate?
    
    private init() { }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        
        requestSender.send(request) { [weak self] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let data):
                if let token = data[request.name]?["token"] as? String {
                    UserInfo.shared.token = token
                }
                strongSelf.delegate?.loginProviderSucceed()
                
            case .apiErrors(let errors):
                strongSelf.delegate?.loginProviderFailedWithErrors(errors)
                
            case .textError(let message):
                strongSelf.delegate?.loginProviderFailedWithMessage(message)
            }
        }
    }
}
