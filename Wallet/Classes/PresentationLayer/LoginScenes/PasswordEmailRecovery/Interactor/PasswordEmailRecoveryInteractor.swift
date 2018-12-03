//
//  PasswordEmailRecoveryPasswordEmailRecoveryInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordEmailRecoveryInteractor {
    weak var output: PasswordEmailRecoveryInteractorOutput!
    
    private var email: String?
    
    private let networkProvider: ResetPasswordNetworkProviderProtocol
    private let resendConfirmEmailNetworkProvider: ResendConfirmEmailNetworkProviderProtocol
    
    init(networkProvider: ResetPasswordNetworkProviderProtocol,
         resendConfirmEmailNetworkProvider: ResendConfirmEmailNetworkProviderProtocol) {
        
        self.networkProvider = networkProvider
        self.resendConfirmEmailNetworkProvider = resendConfirmEmailNetworkProvider
    }
    
}


// MARK: - PasswordEmailRecoveryInteractorInput

extension PasswordEmailRecoveryInteractor: PasswordEmailRecoveryInteractorInput {
    func resetPassword(email: String) {
        self.email = email
        
        networkProvider.resetPassword(email: email, queue: .main) { [weak self] (result) in
            switch result {
            case .success:
                self?.output.emailSentSuccessfully()
            case .failure(let error):
                if let err = error as? ResetPasswordNetworkProviderError {
                    switch err {
                    case .emailNotVerified:
                        self?.output.emailNotVerified()
                        return
                    default: break
                    }
                }
                
                self?.output.emailSendingFailed(message: error.localizedDescription)
            }
        }
    }
    
    func retry() {
        guard let email = email else {
            fatalError("trying to retry password reset without email")
        }
        resetPassword(email: email)
    }
    
    func resendConfirmationEmail() {
        guard let email = email else {
            fatalError("trying to retry password reset without email")
        }
        
        resendConfirmEmailNetworkProvider.confirmAddDevice(
            email: email,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.confirmEmailSentSuccessfully(email: email)
                case .failure(let error):
                    self?.output.confirmEmailSendingFailed(message: error.localizedDescription)
                }
        }
    }
}
