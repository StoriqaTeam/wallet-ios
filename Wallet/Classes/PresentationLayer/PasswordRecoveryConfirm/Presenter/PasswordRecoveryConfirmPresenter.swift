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
    
}


// MARK: - PasswordRecoveryConfirmViewOutput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }

    func confirmReset(newPassword: String) {
        interactor.confirmReset(newPassword: newPassword)
    }
    
    func validateForm(newPassword: String?, passwordConfirm: String?) {
        interactor.validateForm(newPassword: newPassword, passwordConfirm: passwordConfirm)
    }
    
}


// MARK: - PasswordRecoveryConfirmInteractorOutput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmInteractorOutput {
    
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        view.setFormIsValid(valid, passwordsEqualityMessage: passwordsEqualityMessage)
    }

    func passwordRecoverySucceed() {
        router.showSuccess(from: view.viewController)
    }
    
    func passwordRecoveryFailed(message: String) {
        router.showFailure(message: message, from: view.viewController)
    }
    
}


// MARK: - PasswordRecoveryConfirmModuleInput

extension PasswordRecoveryConfirmPresenter: PasswordRecoveryConfirmModuleInput {

    func present(from viewController: UIViewController) {
        view.presentModal(from: viewController)
    }
}
