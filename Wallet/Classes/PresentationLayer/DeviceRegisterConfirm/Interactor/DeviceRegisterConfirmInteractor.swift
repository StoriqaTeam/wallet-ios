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
    
    init(token: String,
         confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        self.token = token
        self.confirmAddDeviceNetworkProvider = confirmAddDeviceNetworkProvider
        self.signHeaderFactory = signHeaderFactory
    }
}


// MARK: - DeviceRegisterConfirmInteractorInput

extension DeviceRegisterConfirmInteractor: DeviceRegisterConfirmInteractorInput {
    func registerDevice() {
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader()
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
