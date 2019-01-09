//
//  ChangePasswordPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ChangePasswordPresenter {
    
    typealias LocalizedStrings = Strings.ChangePassword
    
    weak var view: ChangePasswordViewInput!
    weak var output: ChangePasswordModuleOutput?
    var interactor: ChangePasswordInteractorInput!
    var router: ChangePasswordRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - ChangePasswordViewOutput

extension ChangePasswordPresenter: ChangePasswordViewOutput {
    func validateFields(currentPassword: String?, newPassword: String?, repeatPassword: String?) {
        guard let currentPassword = currentPassword,
            let newPassword = newPassword,
            let repeatPassword = repeatPassword else {
                view.setButtonEnabled(false)
                return
        }
        
        let formIsValid = !currentPassword.isEmpty &&
            !newPassword.isEmpty &&
            !repeatPassword.isEmpty &&
            newPassword == repeatPassword
        
        view.setButtonEnabled(formIsValid)
    }
    
    func validateNewPassword(onEndEditing: Bool, _ password: String?, _ repeatPassword: String?) {
        guard let password = password, !password.isEmpty,
            let repeatPassword = repeatPassword, !repeatPassword.isEmpty else {
                view.setPasswordsEqual(false, message: nil)
                return
        }
        
        if password == repeatPassword {
            view.setPasswordsEqual(onEndEditing, message: nil)
        } else {
            view.setPasswordsEqual(false, message: LocalizedStrings.passwordsNotMatchMessage)
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
        storiqaLoader.startLoader()
        interactor.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    

    func viewIsReady() {
        view.setupInitialState()
        view.setButtonEnabled(false)
        addLoader()
    }

}


// MARK: - ChangePasswordInteractorOutput

extension ChangePasswordPresenter: ChangePasswordInteractorOutput {
    func formValidationFailed(oldPassword: String?, newPassword: String?) {
        storiqaLoader.stopLoader()
        view.showErrorMessage(oldPassword: oldPassword, newPassword: newPassword)
    }
    
    func changePasswordSucceed() {
        storiqaLoader.stopLoader()
        router.showSuccess(popUpDelegate: self, from: view.viewController)
    }
    
    func changePasswordFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, from: view.viewController)
    }
}


// MARK: - ChangePasswordModuleInput

extension ChangePasswordPresenter: ChangePasswordModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PopUpChangePasswordSuccessVMDelegate

extension ChangePasswordPresenter: PopUpChangePasswordSuccessVMDelegate {
    func okButtonPressed() {
        view.dismiss()
    }
}


// MARK: - Private methods

extension ChangePasswordPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.navigationController?.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
