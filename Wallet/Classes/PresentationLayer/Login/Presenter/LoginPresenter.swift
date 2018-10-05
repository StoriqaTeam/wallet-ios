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
    
    func showPasswordRecovery() {
        router.showPasswordRecovery(from: view.viewController)
    }

    func viewIsReady() {
        view.setupInitialState()
        let viewModel = interactor.getSocialVM()
        view.setSocialView(viewModel: viewModel)
    }

    func showRegistration() {
        router.showRegistration()
    }
    
    func signIn(email: String, password: String) {
        interactor.signIn(email: email, password: password)
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, token: String) {
        interactor.signIn(tokenProvider: tokenProvider, socialNetworkToken: token)
    }
    
}


// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {
    
    func loginSucceed() {
        router.showAuthorizedZone()
    }
    
    func showQuickLaunch(authData: AuthData, token: String) {
        router.showQuickLaunch(authData: authData, token: token, from: view.viewController)
    }
    
    func showPinQuickLaunch(authData: AuthData, token: String) {
        router.showPinQuickLaunch(authData: authData, token: token, from: view.viewController)
    }
    
    func loginFailed(message: String) {
        //TODO: display login failure
        
        
        // FIXME: - stub
        
        view.viewController.showAlert(title: "", message: message)
        
        //-----------------------------------------
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
