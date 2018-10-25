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
    
    init(token: String, emailConfirmProvider: EmailConfirmNetworkProviderProtocol) {
        self.token = token
        self.emailConfirmProvider = emailConfirmProvider
    }
}


// MARK: - EmailConfirmInteractorInput

extension EmailConfirmInteractor: EmailConfirmInteractorInput {
    func confirmEmail() {
        emailConfirmProvider.confirm(token: token, queue: .main) { [weak self] (result) in
            switch result {
            case .success:
                self?.output.confirmationSucceed()
                
            case .failure(let error):
                self?.output.confirmationFailed(message: error.localizedDescription)
            }
        }
    }
}
