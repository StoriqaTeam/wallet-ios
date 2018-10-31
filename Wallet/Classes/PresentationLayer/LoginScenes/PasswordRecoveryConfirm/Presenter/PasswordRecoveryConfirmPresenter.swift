//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordRecoveryConfirmPresenter {
    
    weak var view: PasswordRecoveryConfirmViewInput!
    weak var output: PasswordRecoveryConfirmModuleOutput?
    var interactor: PasswordRecoveryConfirmInteractorInput!
    var router: PasswordRecoveryConfirmRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - PasswordRecoveryConfirmViewOutput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        addLoader()
    }

    func confirmReset(newPassword: String) {
        storiqaLoader.startLoader()
        interactor.confirmReset(newPassword: newPassword)
    }
    
    func validateForm(newPassword: String?, passwordConfirm: String?) {
        interactor.validateForm(newPassword: newPassword, passwordConfirm: passwordConfirm)
    }
    
}


// MARK: - PasswordRecoveryConfirmInteractorOutput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmInteractorOutput {
    func formValidationFailed(password: String?) {
        storiqaLoader.stopLoader()
        view.showErrorMessage(password)
    }
    
    
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        view.setFormIsValid(valid, passwordsEqualityMessage: passwordsEqualityMessage)
    }

    func passwordRecoverySucceed() {
        storiqaLoader.stopLoader()
        router.showSuccess(popUpDelegate: self, from: view.viewController)
    }
    
    func passwordRecoveryFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
    }
    
}


// MARK: - PasswordRecoveryConfirmModuleInput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmModuleInput {
    
    func present() {
        view.present()
    }
    
    func present(from viewController: UIViewController) {
        view.presentModal(from: viewController)
    }
    
}


// MARK: - PopUpPasswordRecoveryConfirmSuccessVMDelegate

extension PasswordRecoveryConfirmPresenter: PopUpPasswordRecoveryConfirmSuccessVMDelegate {
    
    func signIn() {
        router.showLogin()
    }
    
}


// MARK: - PopUpPasswordRecoveryConfirmFailedVMDelegate

extension PasswordRecoveryConfirmPresenter: PopUpPasswordRecoveryConfirmFailedVMDelegate {
    
    func retry() {
        storiqaLoader.startLoader()
        interactor.retry()
    }
    
}


// MARK: - Private methods

extension PasswordRecoveryConfirmPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
