//
//  FeeLoader.swift
//  Wallet
//
//  Created by Storiqa on 21/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol FeeLoaderProtocol {
    func getFees(currency: Currency,
                 accountAddress: String,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void)
}


class FeeLoader: FeeLoaderProtocol {
    
    private let userDataStore: UserDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let feeNetworkProvider: FeeNetworkProviderProtocol
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    init(userDataStore: UserDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         feeNetworkProvider: FeeNetworkProviderProtocol) {
        self.userDataStore = userDataStore
        self.authTokenProvider = authTokenProvider
        self.signHeaderFactory = signHeaderFactory
        self.feeNetworkProvider = feeNetworkProvider
    }
    
    func getFees(currency: Currency,
                 accountAddress: String,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void) {
        pendingRequestWorkItem?.cancel()
        
        let address: String = {
            switch currency {
            case .eth, .stq:
                if accountAddress.count == 42 {
                    return String(accountAddress.suffix(40)).lowercased()
                }
                
                return accountAddress.lowercased()
            default:
                return accountAddress
            }
        }()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.authTokenProvider.currentAuthToken { [weak self] (result) in
                switch result {
                case .success(let token):
                    self?.getFees(authToken: token,
                                  currency: currency,
                                  accountAddress: address,
                                  completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
}

extension FeeLoader {
    func getFees(authToken: String,
                 currency: Currency,
                 accountAddress: String,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void) {
        let currentEmail = userDataStore.getCurrentUser().email
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        feeNetworkProvider.getFees(
            authToken: authToken,
            currency: currency,
            accountAddress: accountAddress,
            signHeader: signHeader,
            queue: .main) {
                completion($0)
        }
    }
}
