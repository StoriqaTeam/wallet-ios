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
    
    init(token: String,
         emailConfirmProvider: EmailConfirmNetworkProviderProtocol,
         authTokenDefaults: AuthTokenDefaultsProviderProtocol) {
        
        self.token = token
        self.authTokenDefaults = authTokenDefaults
        self.emailConfirmProvider = emailConfirmProvider
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - EmailConfirmInteractorInput

extension EmailConfirmInteractor: EmailConfirmInteractorInput {
    @objc func confirmEmail() {
        guard case .active = AppDelegate.currentApplication.applicationState else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(confirmEmail),
                                                   name: UIApplication.didBecomeActiveNotification,
                                                   object: nil)
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        
        emailConfirmProvider.confirm(token: token, queue: .main) { [weak self] (result) in
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
