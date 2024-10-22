//
//  EditProfileInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EditProfileInteractor {
    weak var output: EditProfileInteractorOutput!
    
    private let userDataStore: UserDataStoreServiceProtocol
    private let updateUserNetworkProvider: UpdateUserNetworkProviderProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private var user: User
    private var userUpadateChannelOutput: UserUpdateChannel?
    
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
    
    func setUserUpdaterChannel(_ channel: UserUpdateChannel) {
        guard userUpadateChannelOutput == nil else {
            return
        }
        
        self.userUpadateChannelOutput = channel
    }
}


// MARK: - EditProfileInteractorInput

extension EditProfileInteractor: EditProfileInteractorInput {
    
    func getCurrentUser() -> User {
        return user
    }
    
    func updateUser(firstName: String, lastName: String) {
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.updateUser(authToken: token, firstName: firstName, lastName: lastName)
            case .failure(let error):
                self?.output.userUpdateFailed(message: error.localizedDescription)
            }
        }
    }
}


// MARK: - Private methods

extension EditProfileInteractor {
    private func updateUser(authToken: String, firstName: String, lastName: String) {
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: user.email)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        updateUserNetworkProvider.updateUser(
            authToken: authToken,
            firstName: firstName,
            lastName: lastName,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.userDataStore.save(user)
                    self?.userUpadateChannelOutput?.send(user)
                    self?.output.userUpdatedSuccessfully()
                case .failure(let error):
                    self?.output.userUpdateFailed(message: error.localizedDescription)
                }
        }
    }
}
