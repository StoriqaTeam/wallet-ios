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
    
}


// MARK: - LoginViewOutput

extension LoginPresenter: LoginViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }

    func showRegistration() {
        router.showRegistration()
    }
}


// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {

}


// MARK: - LoginModuleInput

extension LoginPresenter: LoginModuleInput {
    
    func present() {
        view.present()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
