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
    }

    func showRegistration() {
        router.showRegistration()
    }
    
    func signIn(email: String, password: String) {
        storiqaLoader.startLoader()
        interactor.signIn(email: email, password: password)
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, token: String) {
        storiqaLoader.startLoader()
        interactor.signIn(tokenProvider: tokenProvider, socialNetworkToken: token)
    }
    
}


// MARK: - LoginInteractorOutput

extension LoginPresenter: LoginInteractorOutput {
    func failToLogin(reason: String) {
        storiqaLoader.stopLoader()
        router.showFailurePopup(message: reason, popUpDelegate: self, from: view.viewController)
    }
    
    func loginSucceed() {
        storiqaLoader.stopLoader()
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


// MARK: - PopUpRegistrationFailedVMDelegate

extension LoginPresenter: PopUpRegistrationFailedVMDelegate {
    func retry() {
        view.relogin()
    }
}


// MARK: - Private methods

extension LoginPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
