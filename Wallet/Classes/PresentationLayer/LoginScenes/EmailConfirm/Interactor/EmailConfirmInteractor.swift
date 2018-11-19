//
//  EmailConfirmInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EmailConfirmInteractor {
    weak var output: EmailConfirmInteractorOutput!
    
    private let token: String
    private let emailConfirmProvider: EmailConfirmNetworkProviderProtocol
    private let authTokenDefaults: AuthTokenDefaultsProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    init(token: String,
         emailConfirmProvider: EmailConfirmNetworkProviderProtocol,
         authTokenDefaults: AuthTokenDefaultsProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        
        self.token = token
        self.authTokenDefaults = authTokenDefaults
        self.emailConfirmProvider = emailConfirmProvider
        self.signHeaderFactory = signHeaderFactory
    }
}


// MARK: - EmailConfirmInteractorInput

extension EmailConfirmInteractor: EmailConfirmInteractorInput {
    func confirmEmail() {
        
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader()
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        emailConfirmProvider.confirm(token: token, queue: .main, signHeader: signHeader) { [weak self] (result) in
            switch result {
            case .success(let authToken):
                self?.authTokenDefaults.authToken = authToken
                self?.output.confirmationSucceed()
            case .failure(let error):
                self?.output.confirmationFailed(message: error.localizedDescription)
            }
        }
    }
}
