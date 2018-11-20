//
//  DeviceRegisterConfirmPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DeviceRegisterConfirmPresenter {
    
    weak var view: DeviceRegisterConfirmViewInput!
    weak var output: DeviceRegisterConfirmModuleOutput?
    var interactor: DeviceRegisterConfirmInteractorInput!
    var router: DeviceRegisterConfirmRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - DeviceRegisterConfirmViewOutput

extension DeviceRegisterConfirmPresenter: DeviceRegisterConfirmViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        addLoader()
        registerDevice()
    }

}


// MARK: - DeviceRegisterConfirmInteractorOutput

extension DeviceRegisterConfirmPresenter: DeviceRegisterConfirmInteractorOutput {
    func confirmationSucceed() {
        router.showSuccess(popUpDelegate: self, from: view.viewController)
    }
    
    func confirmationFailed(message: String) {
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
    }
}


// MARK: - DeviceRegisterConfirmModuleInput

extension DeviceRegisterConfirmPresenter: DeviceRegisterConfirmModuleInput {
    func present() {
        view.presentAsNavController()
    }
}


// MARK: - PopUpConfirmDeviceRegisterSucceedVMDelegate

extension DeviceRegisterConfirmPresenter: PopUpConfirmDeviceRegisterSucceedVMDelegate {
    func signIn() {
        router.showLogin()
    }
}


// MARK: - PopUpPasswordRecoveryConfirmFailedVMDelegate

extension DeviceRegisterConfirmPresenter: PopUpPasswordRecoveryConfirmFailedVMDelegate {
    func retry() {
        registerDevice()
    }
}


// MARK: - Private methods

extension DeviceRegisterConfirmPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: "Registring device")
    }
    
    private func registerDevice() {
        storiqaLoader.startLoader()
        interactor.registerDevice()
    }
}
