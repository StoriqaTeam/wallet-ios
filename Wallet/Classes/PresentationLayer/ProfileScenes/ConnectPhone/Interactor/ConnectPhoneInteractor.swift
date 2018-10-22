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
    
    private let userStoreService: UserDataStoreServiceProtocol
    private var user: User
    
    init(userStoreService: UserDataStoreServiceProtocol) {
        self.userStoreService = userStoreService
        self.user = userStoreService.getCurrentUser()
    }
}


// MARK: - ConnectPhoneInteractorInput

extension ConnectPhoneInteractor: ConnectPhoneInteractorInput {
    
    func getUserPhone() -> String {
        return user.phone
    }
    
    func updateUserPhone(_ phone: String) {
        user.phone = phone
        userStoreService.save(user)
    }
    
}
