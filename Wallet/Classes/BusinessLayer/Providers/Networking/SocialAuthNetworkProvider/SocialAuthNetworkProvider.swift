//
//  SocialAuthNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 06/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SocialAuthNetworkProviderProtocol {
    func socialAuth(oauthToken: String,
                    oauthProvider: SocialNetworkTokenProvider,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping (Result<String>) -> Void)
}

class SocialAuthNetworkProvider: NetworkLoadable, SocialAuthNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createSocialAuthErrorResolver()
    }
    
    func socialAuth(oauthToken: String,
                    oauthProvider: SocialNetworkTokenProvider,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping (Result<String>) -> Void) {
        

        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
        
        let request = API.Unauthorized.socialAuth(oauthToken: oauthToken,
                                                  oauthProvider: oauthProvider,
                                                  deviceType: deviceType,
                                                  deviceOs: deviceOs,
                                                  signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let token = json["token"].string else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
               
                completion(.success(token))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
}
