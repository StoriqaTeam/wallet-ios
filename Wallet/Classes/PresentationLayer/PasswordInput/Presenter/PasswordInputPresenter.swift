//
//  PasswordInputPasswordInputPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PasswordInputPresenter: NSObject {
    
    weak var view: PasswordInputViewInput!
    weak var output: PasswordInputModuleOutput?
    var interactor: PasswordInputInteractorInput!
    var router: PasswordInputRouterInput!
    
    let kPasswordDigits = 4
    
}


// MARK: - PasswordInputViewOutput

extension PasswordInputPresenter: PasswordInputViewOutput {
    func setPasswordView(in stackView: UIStackView) -> PasswordContainerView  {
        let passView = PasswordContainerView.create(in: stackView, digit: kPasswordDigits)
        passView.delegate = self
        passView.tintColor = UIColor.mainBlue
        passView.highlightedColor = UIColor.mainBlue
        return passView
    }

    func viewIsReady() {
        view.setupInitialState()
    }

}


// MARK: - PasswordInputInteractorOutput

extension PasswordInputPresenter: PasswordInputInteractorOutput {

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


// MARK: - PasswordInputCompleteProtocol
extension PasswordInputPresenter: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: String?) {
        
    }
}



