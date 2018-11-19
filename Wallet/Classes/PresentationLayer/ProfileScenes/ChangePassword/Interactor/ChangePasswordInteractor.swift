//
//  ChangePasswordInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ChangePasswordInteractor {
    weak var output: ChangePasswordInteractorOutput!
    
    private let authTokenProvider: AuthTokenProviderProtocol
    private let networkProvider: ChangePasswordNetworkProviderProtocol
    private let keychain: KeychainProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    init(authTokenProvider: AuthTokenProviderProtocol,
         networkProvider: ChangePasswordNetworkProviderProtocol,
         keychain: KeychainProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        self.authTokenProvider = authTokenProvider
        self.networkProvider = networkProvider
        self.keychain = keychain
        self.signHeaderFactory = signHeaderFactory
    }
}


// MARK: - ChangePasswordInteractorInput

extension ChangePasswordInteractor: ChangePasswordInteractorInput {
    func changePassword(currentPassword: String, newPassword: String) {
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.changePassword(authToken: token, currentPassword: currentPassword, newPassword: newPassword)
            case .failure(let error):
                self?.output.changePasswordFailed(message: error.localizedDescription)
            }
        }
    }
}


// MARK: - Private methods

extension ChangePasswordInteractor {
    private func changePassword(authToken: String, currentPassword: String, newPassword: String) {
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader()
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        networkProvider.changePassword(
            authToken: authToken,
            currentPassword: currentPassword,
            newPassword: newPassword,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.changePasswordSucceed()
                    self?.keychain.password = newPassword
                case .failure(let error):
                    if let error = error as? ChangePasswordNetworkProviderError {
                        switch error {
                        case .validationError(let oldPassword, let newPassword):
                            self?.output.formValidationFailed(oldPassword: oldPassword, newPassword: newPassword)
                            return
                        default: break
                        }
                    }
                    
                    self?.output.changePasswordFailed(message: error.localizedDescription)
                }
        }
    }
}
