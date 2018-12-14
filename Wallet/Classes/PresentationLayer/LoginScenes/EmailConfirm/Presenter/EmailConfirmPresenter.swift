//
//  EmailConfirmPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EmailConfirmPresenter {
    
    typealias LocalizedString = Strings.EmailConfirm
    
    weak var view: EmailConfirmViewInput!
    weak var output: EmailConfirmModuleOutput?
    var interactor: EmailConfirmInteractorInput!
    var router: EmailConfirmRouterInput!
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - EmailConfirmViewOutput

extension EmailConfirmPresenter: EmailConfirmViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        addLoader()
        configureNavBar()
        confirmEmail()
    }

}


// MARK: - EmailConfirmInteractorOutput

extension EmailConfirmPresenter: EmailConfirmInteractorOutput {
    func confirmationSucceed() {
        storiqaLoader.stopLoader()
        router.showSuccess(popUpDelegate: self, from: view.viewController)
    }
    
    func confirmationFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
    }
}


// MARK: - EmailConfirmModuleInput

extension EmailConfirmPresenter: EmailConfirmModuleInput {
    func present() {
        view.presentAsNavController()
    }
}


// MARK: - PopUpEmailConfirmSuccessVMDelegate

extension EmailConfirmPresenter: PopUpEmailConfirmSuccessVMDelegate {
    func signInButtonPressed() {
        router.showLogin()
    }
}


// MARK: - PopUpEmailConfirmFailedVMDelegate

extension EmailConfirmPresenter: PopUpEmailConfirmFailedVMDelegate {
    func retryButtonPressed() {
        confirmEmail()
    }
    
    func cancelButtonPressed() {
        router.showLogin()
    }
}


// MARK: - Private methods

extension EmailConfirmPresenter {
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: LocalizedString.navigationTitle)
    }
    
    private func confirmEmail() {
        storiqaLoader.startLoader()
        interactor.confirmEmail()
    }
}
