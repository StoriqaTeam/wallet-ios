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
    private let defaults: DefaultsProviderProtocol
    
    init(token: String,
         confirmAddDeviceNetworkProvider: ConfirmAddDeviceNetworkProviderProtocol,
         defaults: DefaultsProviderProtocol) {
        
        self.token = token
        self.confirmAddDeviceNetworkProvider = confirmAddDeviceNetworkProvider
        self.defaults = defaults
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - DeviceRegisterConfirmInteractorInput

extension DeviceRegisterConfirmInteractor: DeviceRegisterConfirmInteractorInput {
    @objc func registerDevice() {
        guard case .active = AppDelegate.currentApplication.applicationState else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(registerDevice),
                                                   name: UIApplication.didBecomeActiveNotification,
                                                   object: nil)
            return
        }
        
        NotificationCenter.default.removeObserver(self)
        
        let deviceId = defaults.deviceId
        
        confirmAddDeviceNetworkProvider.confirmAddDevice(
            deviceConfirmToken: token,
            deviceId: deviceId,
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
