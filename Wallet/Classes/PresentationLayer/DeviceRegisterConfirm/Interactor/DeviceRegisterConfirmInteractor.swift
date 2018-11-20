//
//  DeviceRegisterConfirmInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class DeviceRegisterConfirmInteractor {
    weak var output: DeviceRegisterConfirmInteractorOutput!
    
    private let token: String
    private let confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    
    init(token: String,
         confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        self.token = token
        self.confirmAddDeviceNetworkProvider = confirmAddDeviceNetworkProvider
        self.signHeaderFactory = signHeaderFactory
        self.userDataStoreService = userDataStoreService
    }
}


// MARK: - DeviceRegisterConfirmInteractorInput

extension DeviceRegisterConfirmInteractor: DeviceRegisterConfirmInteractorInput {
    func registerDevice() {
        let currentEmail = userDataStoreService.getCurrentUser().email
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        confirmAddDeviceNetworkProvider.confirmAddDevice(
            deviceConfirmToken: token,
            signHeader: signHeader,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.confirmationSucceed()
                case .failure(let error):
                    self?.output.confirmationFailed(message: error.localizedDescription)
                }
        }
    }
}
