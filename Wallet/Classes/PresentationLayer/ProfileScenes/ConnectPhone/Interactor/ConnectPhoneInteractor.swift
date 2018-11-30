//
//  ConnectPhoneInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ConnectPhoneInteractor {
    weak var output: ConnectPhoneInteractorOutput!
    
    private let userDataStore: UserDataStoreServiceProtocol
    private let updateUserNetworkProvider: UpdateUserNetworkProviderProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private var user: User
    
    init(userDataStore: UserDataStoreServiceProtocol,
         updateUserNetworkProvider: UpdateUserNetworkProviderProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        self.userDataStore = userDataStore
        self.updateUserNetworkProvider = updateUserNetworkProvider
        self.authTokenProvider = authTokenProvider
        self.signHeaderFactory = signHeaderFactory
        user = userDataStore.getCurrentUser()
    }
}


// MARK: - ConnectPhoneInteractorInput

extension ConnectPhoneInteractor: ConnectPhoneInteractorInput {
    func getUserPhone() -> String {
        return user.phone
    }
    
    func updateUserPhone(_ phone: String) {
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.updateUser(authToken: token, phone: phone)
            case .failure(let error):
                self?.output.userUpdateFailed(message: error.localizedDescription)
            }
        }
    }
}


// MARK: - Private methods

extension ConnectPhoneInteractor {
    private func updateUser(authToken: String, phone: String) {
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: user.email)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        updateUserNetworkProvider.updateUser(
            authToken: authToken,
            phone: phone,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.userDataStore.save(user)
                    self?.output.userUpdatedSuccessfully()
                case .failure(let error):
                    self?.output.userUpdateFailed(message: error.localizedDescription)
                }
        }
    }
}
