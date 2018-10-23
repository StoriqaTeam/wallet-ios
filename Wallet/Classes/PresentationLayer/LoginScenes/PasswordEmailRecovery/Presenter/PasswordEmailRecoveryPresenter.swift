//
//  PasswordEmailRecoveryPasswordEmailRecoveryPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordEmailRecoveryPresenter {
    
    weak var view: PasswordEmailRecoveryViewInput!
    weak var output: PasswordEmailRecoveryModuleOutput?
    var interactor: PasswordEmailRecoveryInteractorInput!
    var router: PasswordEmailRecoveryRouterInput!
    
}


// MARK: - PasswordEmailRecoveryViewOutput

extension PasswordEmailRecoveryPresenter: PasswordEmailRecoveryViewOutput {
    
    func resetPassword(email: String) {
       interactor.resetPassword(email: email)
    }

    func viewIsReady() {
        view.setupInitialState()
        view.viewController.setDarkNavigationBarButtons()
    }
    
}


// MARK: - PasswordEmailRecoveryInteractorOutput

extension PasswordEmailRecoveryPresenter: PasswordEmailRecoveryInteractorOutput {
    func setFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    
    func emailSentSuccessfully() {
        router.showSuccess(popUpDelegate: self, from: view.viewController)
    }
    
    func emailSendingFailed(message: String) {
        router.showFailure(message: message, popUpDelegate: self, from: view.viewController)
    }
    
}


// MARK: - PasswordEmailRecoveryModuleInput

extension PasswordEmailRecoveryPresenter: PasswordEmailRecoveryModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
    
}


// MARK: - PopUpPasswordEmailRecoverySuccessVMDelegate

extension PasswordEmailRecoveryPresenter: PopUpPasswordEmailRecoverySuccessVMDelegate {
    
    func closePasswordRecovery() {
        view.dismiss()
    }
    
}


// MARK: - PopUpPasswordEmailRecoveryFailedVMDelegate

extension PasswordEmailRecoveryPresenter: PopUpPasswordEmailRecoveryFailedVMDelegate {
    
    func retry() {
        interactor.retry()
    }
}
