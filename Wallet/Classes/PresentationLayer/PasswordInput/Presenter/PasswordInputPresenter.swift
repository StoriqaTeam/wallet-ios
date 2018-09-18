//
//  PasswordInputPasswordInputPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordInputPresenter {
    
    weak var view: PasswordInputViewInput!
    weak var output: PasswordInputModuleOutput?
    var interactor: PasswordInputInteractorInput!
    var router: PasswordInputRouterInput!
    
}


// MARK: - PasswordInputViewOutput

extension PasswordInputPresenter: PasswordInputViewOutput {
    func setPasswordView(view: PasswordContainerView) {
        
    }

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func passwordInputComplete(_ password: String) {
        interactor.validatePassword(password)
    }

}


// MARK: - PasswordInputInteractorOutput

extension PasswordInputPresenter: PasswordInputInteractorOutput {
    func passwordIsCorrect() {
        view.pinValidationSuccess()
    }
    
    func passwordIsWrong() {
        view.pinValidationFail()
    }
}


// MARK: - PasswordInputModuleInput

extension PasswordInputPresenter: PasswordInputModuleInput {
    
    func present() {
        view.present()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
