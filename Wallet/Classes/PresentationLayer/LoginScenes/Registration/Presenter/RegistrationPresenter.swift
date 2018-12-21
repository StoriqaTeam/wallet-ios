//
//  RegistrationRegistrationPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class RegistrationPresenter {
    
    typealias LocalizedStrings = Strings.Registration
    
    weak var view: RegistrationViewInput!
    weak var output: RegistrationModuleOutput?
    var interactor: RegistrationInteractorInput!
    var router: RegistrationRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        let viewModel = interactor.getSocialVM()
        view.setSocialView(viewModel: viewModel)
        addLoader()
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        let registrationData = RegistrationData(firstName: firstName, lastName: lastName, email: email, password: password)
        storiqaLoader.startLoader()
        interactor.register(with: registrationData)
    }
    
    func validateFields(firstName: String?,
                        lastName: String?,
                        email: String?,
                        password: String?,
                        repeatPassword: String?,
                        agreement: Bool,
                        privacy: Bool) {
        
        let form = RegistrationForm(firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    password: password,
                                    repeatPassword: repeatPassword,
                                    agreement: agreement,
                                    policy: privacy)
        
        interactor.validateForm(form)
    }
    
    func validatePasswords(onEndEditing: Bool, password: String?, repeatPassword: String?) {
        guard let password = password, !password.isEmpty,
            let repeatPassword = repeatPassword, !repeatPassword.isEmpty else {
                view.setPasswordsEqual(false, message: nil)
                return
        }
        
        if password == repeatPassword {
            view.setPasswordsEqual(onEndEditing, message: nil)
        } else {
            view.setPasswordsEqual(false, message: LocalizedStrings.passwordsNonEqualMessage)
        }
    }
    
    func showLogin() {
        router.showLogin(animated: true)
    }
    
    func socialNetworkRegisterSucceed(provider: SocialNetworkTokenProvider, token: String, email: String) {
        storiqaLoader.startLoader()
        interactor.signIn(tokenProvider: provider, oauthToken: token, email: email)
    }
    
    func socialNetworkRegisterFailed(tokenProvider: SocialNetworkTokenProvider) {
        let failSocial = LocalizedStrings.failRetrieveSocialDataMessage
        let message = failSocial + tokenProvider.displayableName
        router.showSocialNetworkFailure(message: message, from: view.viewController)
    }
    
}


// MARK: - RegistrationInteractorOutput

extension RegistrationPresenter: RegistrationInteractorOutput {
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
    
    func formValidationFailed(email: String?, password: String?) {
        storiqaLoader.stopLoader()
        view.showErrorMessage(email: email, password: password)
    }
    
    func setFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    func registrationSucceed(email: String) {
        storiqaLoader.stopLoader()
        router.showSuccess(email: email, popUpDelegate: self, from: view.viewController)
    }
    
    func registrationFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
    }
    
    func showQuickLaunch() {
        storiqaLoader.stopLoader()
        router.showQuickLaunch(from: view.viewController)
    }
    
    func showPinQuickLaunch() {
        storiqaLoader.stopLoader()
        router.showPinQuickLaunch(from: view.viewController)
    }
    
    func socialAuthFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showSocialNetworkFailure(message: message, from: view.viewController)
    }
}


// MARK: - RegistrationModuleInput

extension RegistrationPresenter: RegistrationModuleInput {
    func present() {
        view.present()
    }
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension RegistrationPresenter: PopUpRegistrationSuccessVMDelegate {
    func okButtonPressed() {
        router.showLogin(animated: false)
    }
}


// MARK: - PopUpRegistrationFailedVMDelegate

extension RegistrationPresenter: PopUpRegistrationFailedVMDelegate {
    func retry() {
        storiqaLoader.startLoader()
        interactor.retryRegistration()
    }
}

// MARK: - PopUpDeviceRegisterVMDelegate

extension RegistrationPresenter: PopUpDeviceRegisterVMDelegate {
    func deviceRegisterOkButtonPressed() {
        storiqaLoader.startLoader()
        interactor.registerDevice()
    }
}


// MARK: - PopUpDeviceRegisterFailedSendEmailVMDelegate

extension RegistrationPresenter: PopUpDeviceRegisterFailedSendEmailVMDelegate {
    func retryDeviceRegister() {
        storiqaLoader.startLoader()
        interactor.registerDevice()
    }
}

// MARK: - Private methods

extension RegistrationPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
