//
//  RegistrationRegistrationPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RegistrationPresenter {
    
    weak var view: RegistrationViewInput!
    weak var output: RegistrationModuleOutput?
    var interactor: RegistrationInteractorInput!
    var router: RegistrationRouterInput!
    
}


// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }

    func register(firstName: String, lastName: String, email: String, password: String) {
        interactor.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func validateFields(firstName: String?,
                        lastName: String?,
                        email: String?,
                        password: String?,
                        repeatPassword: String?,
                        agreement: Bool) {
        
        let form = RegistrationForm(firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    password: password,
                                    repeatPassword: repeatPassword,
                                    agreement: agreement)
        interactor.validateForm(form)
    }
    
    func showLogin() {
        router.showLogin()
    }
    
}


// MARK: - RegistrationInteractorOutput

extension RegistrationPresenter: RegistrationInteractorOutput {
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        view.setButtonEnabled(valid)
        view.showPasswordsNotEqual(message: passwordsEqualityMessage)
    }
    
    func setPasswordsNotEqual(message: String?) {
        view.showPasswordsNotEqual(message: message)
    }
    
    func registrationSucceed(email: String) {
        view.showSuccess(email: email)
    }
    
    func registrationFailed(message: String) {
        view.showError(message: message)
    }
    
    func registrationFailed(apiErrors: [ResponseAPIError.Message]) {
        view.showApiErrors(apiErrors)
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
