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

protocol LoginProviderDelegate: class {
    func loginProviderSucceed()
    func loginProviderFailedWithMessage(_ message: String)
    func loginProviderFailedWithApiErrors(_ errors: [ResponseAPIError.Message])
}

class LoginProvider {
    static let shared = LoginProvider()
    var requestSender: AbstractRequestSender
    weak var delegate: LoginProviderDelegate?
    
    private init() {
        requestSender = RequestSender()
        requestSender.delegate = self
    }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, password: password)
        requestSender.sentGrqphQLRequest(request)
    }
    
    func login(provider: SocialNetworkTokenProvider, authToken: String) {
        let request = SocialNetworkAuthRequest(provider: provider, authToken: authToken)
        requestSender.sentGrqphQLRequest(request)
    }
}

extension LoginProvider: RequestSenderDelegate {
    func requestSucceed(_ request: Request, data: [String: AnyObject]) {
        if let token = data[request.name]?["token"] as? String {
            UserInfo.shared.token = token
        }
        delegate?.loginProviderSucceed()
    }
    
    func requestFailed(_ request: Request, apiErrors: [ResponseAPIError.Message]) {
        delegate?.loginProviderFailedWithApiErrors(apiErrors)
    }
    
    func requestFailed(_ request: Request, message: String) {
        delegate?.loginProviderFailedWithMessage(message)
    }
}
