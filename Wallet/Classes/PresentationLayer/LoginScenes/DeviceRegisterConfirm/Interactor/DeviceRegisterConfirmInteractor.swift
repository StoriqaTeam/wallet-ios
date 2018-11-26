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
    
    init(token: String,
         confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol) {
        
        self.token = token
        self.confirmAddDeviceNetworkProvider = confirmAddDeviceNetworkProvider
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - DeviceRegisterConfirmInteractorInput

extension DeviceRegisterConfirmInteractor: DeviceRegisterConfirmInteractorInput {
    @objc func registerDevice() {
        guard case .active = AppDelegate.currenctApplication.applicationState else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(registerDevice),
                                                   name: UIApplication.didBecomeActiveNotification,
                                                   object: nil)
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        
        confirmAddDeviceNetworkProvider.confirmAddDevice(
            deviceConfirmToken: token,
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
