//
//  ResetPasswordNetworkProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ResetPasswordNetworkProviderProtocol {
    
    func resetPassword(authToken: String, email: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void)
}


class ResetPasswordNetworkProvider: NetworkLoadable, ResetPasswordNetworkProviderProtocol {
    func resetPassword(authToken: String, email: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Authorized.resetPassword(authToken: authToken, email: email)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
