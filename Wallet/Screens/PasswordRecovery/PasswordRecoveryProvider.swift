//
//  PasswordRecoveryProvider.swift
//  Wallet
//
//  Created by user on 13.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryProvider {
    static let shared = PasswordRecoveryProvider()
    var requestSender: AbstractRequestSender = RequestSender()
    weak var delegate: ProviderDelegate?
    
    private init() { }
    
    func resetPassword(email: String) {
        let request = PasswordRecoveryRequest(email: email)
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
                if let success = data[request.name]?["success"] as? Bool {
                    //TODO:может ли вернуться false в поле success?
                    delegate.providerSucceed()
                } else {
                    delegate.providerFailedWithMessage(Constants.Errors.serverResponse)
                }
                
            case .textError(let message):
                delegate.providerFailedWithMessage(message)
                
            case .apiErrors(let apiErrors):
                delegate.providerFailedWithApiErrors(apiErrors)
            }
        }
    }
}
