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
        let vm = interactor.getSocialVM()
        view.setSocialView(viewModel: vm)
    }

    func register(firstName: String, lastName: String, email: String, password: String) {
        let registrationData = RegistrationData(firstName: firstName, lastName: lastName, email: email, password: password)
        interactor.register(registrationData: registrationData)
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
    
    func socialNetworkRegisterSucceed() {
        //TODO: будем ли передавать email
        router.showSuccess(email: "", popUpDelegate: self, from: view.viewController)
    }
    
    func socialNetworkRegisterFailed() {
        //TODO: сообщение при регистрации через соц сети
        router.showSocialNetworkFailure(message: Constants.Errors.userFriendly, from: view.viewController)
    }
    
}


// MARK: - RegistrationInteractorOutput

extension RegistrationPresenter: RegistrationInteractorOutput {
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?) {
        view.setButtonEnabled(valid)
        view.showPasswordsNotEqual(message: passwordsEqualityMessage)
    }
    
    func registrationSucceed(email: String) {
        router.showSuccess(email: email, popUpDelegate: self, from: view.viewController)
    }
    
    func registrationFailed(message: String) {
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
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
    
    func showAuthorizedZone() {
        router.showAuthorizedZone()
    }
    
}



// MARK: - PopUpRegistrationFailedVMDelegate

extension RegistrationPresenter: PopUpRegistrationFailedVMDelegate {
    
    func retry() {
        interactor.retryRegistration()
    }
    
}



