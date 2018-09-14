//
//  PasswordRecoveryConfirmProvider.swift
//  Wallet
//
//  Created by user on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryConfirmProvider {
    static let shared = PasswordRecoveryConfirmProvider()
    var requestSender: AbstractRequestSender = RequestSender()
    weak var delegate: PasswordRecoveryProviderDelegate?
    
    private init() { }
    
    func confirmReset(token: String, password: String) {
        let request = PasswordRecoveryConfirmRequest(token: token, password: password)
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
                    delegate.passwordRecoveryProviderSucceed()
                } else {
                    delegate.passwordRecoveryProviderFailedWithMessage(Constants.Errors.serverResponse)
                }
                
            case .textError(let message):
                delegate.passwordRecoveryProviderFailedWithMessage(message)
                
            case .apiErrors(let apiErrors):
                delegate.passwordRecoveryProviderFailedWithApiErrors(apiErrors)
            }
        }
    }
}
