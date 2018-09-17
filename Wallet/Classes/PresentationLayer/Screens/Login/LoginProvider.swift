//
//  LoginProvider.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum SocialNetworkTokenProvider {
    case google
    case facebook
    
    var name: String {
        switch self {
        case .google:
            return "GOOGLE"
        case .facebook:
            return "FACEBOOK"
        }
    }
}

class LoginProvider {
    static let shared = LoginProvider()
    var requestSender: AbstractRequestSender = RequestSender()
    weak var delegate: ProviderDelegate?
    
    private init() { }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        requestSender.sendGrqphQLRequest(request) {[weak self] (response) in
            guard let strongSelf = self else {
                log.warn("self is nil")
                return
            }
            
            strongSelf.parseResponse(response, request: request)
        }
    }
    
    func login(provider: SocialNetworkTokenProvider, authToken: String) {
        let request = SocialNetworkAuthRequest(provider: provider, authToken: authToken)
        requestSender.sendGrqphQLRequest(request) {[weak self] (response) in
            guard let strongSelf = self else {
                log.warn("self is nil")
                return
            }
            
            strongSelf.parseResponse(response, request: request)
        }
    }
    
    private func parseResponse(_ response: ResponseType, request: Request) {
        guard let delegate = delegate else {
            log.warn("delegate is nil")
            return
        }
        
        switch response {
        case .success(let data):
            log.debug(data)
            //TODO: хранить в keychain?
            if let token = data[request.name]?["token"] as? String {
                UserInfo.shared.token = token
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
