//
//  LoginLoginPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class LoginPresenter {
    
    weak var view: LoginViewInput!
    weak var output: LoginModuleOutput?
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
    
}


// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {
    
    func showPasswordRecovery() {
        router.showPasswordRecovery(from: view.viewController)
    }

    func viewIsReady() {
        view.setupInitialState()
        let viewModel = interactor.getSocialVM()
        view.setSocialView(viewModel: viewModel)
        addLoader()
        interactor.viewIsReady()
    }

    func showRegistration() {
        router.showRegistration()
    }
    
    func signIn(email: String, password: String) {
        storiqaLoader.startLoader()
        interactor.signIn(email: email, password: password)
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, token: String, email: String) {
        storiqaLoader.startLoader()
        interactor.signIn(tokenProvider: tokenProvider, oauthToken: token, email: email)
    }
    
}


// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {
    func loginSucceed() {
        storiqaLoader.stopLoader()
        router.showAuthorizedZone()
    }
    
    func showQuickLaunch() {
        router.showQuickLaunch(from: view.viewController)
    }
    
    func showPinQuickLaunch() {
        router.showPinQuickLaunch(from: view.viewController)
    }
    
    func loginFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailurePopup(message: message, popUpDelegate: self, from: view.viewController)
    }
    
    func formValidationFailed(email: String?, password: String?) {
        storiqaLoader.stopLoader()
        view.showErrorMessage(email: email, password: password)
    }
    
    func deviceNotRegistered() {
        storiqaLoader.stopLoader()
        router.showDeviceRegister(popUpDelegate: self, from: view.viewController)
    }
    
    func deviceRegisterEmailSent() {
        storiqaLoader.stopLoader()
        router.showDeviceRegisterEmailSent(from: view.viewController)
    }
    
    func failedSendDeviceRegisterEmail(message: String) {
        storiqaLoader.stopLoader()
        router.showDeviceRegisterFailedSendEmail(message: message, popUpDelegate: self, from: view.viewController)
    }
}


// MARK: - LoginModuleInput

extension LoginPresenter: LoginModuleInput {
    func present() {
        view.presentAsNavController()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PopUpRegistrationFailedVMDelegate

extension LoginPresenter: PopUpRegistrationFailedVMDelegate {
    func retry() {
        storiqaLoader.startLoader()
        interactor.retry()
    }
}


// MARK: - PopUpDeviceRegisterVMDelegate

extension LoginPresenter: PopUpDeviceRegisterVMDelegate {
    func okButtonPressed() {
        storiqaLoader.startLoader()
        interactor.registerDevice()
    }
}


// MARK: - PopUpDeviceRegisterFailedSendEmailVMDelegate

extension LoginPresenter: PopUpDeviceRegisterFailedSendEmailVMDelegate {
    func retryDeviceRegister() {
        storiqaLoader.startLoader()
        interactor.registerDevice()
    }
}


// MARK: - Private methods

extension LoginPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
