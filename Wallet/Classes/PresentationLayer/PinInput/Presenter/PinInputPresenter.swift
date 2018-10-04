//
//  PinInputPasswordInputPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AudioToolbox


class PinInputPresenter {
    
    weak var view: PinInputViewInput!
    weak var output: PinInputModuleOutput?
    var interactor: PinInputInteractorInput!
    var router: PinInputRouterInput!
    
    private let kPasswordDigits = 4
    
}


// MARK: - PinInputViewOutput

extension PinInputPresenter: PinInputViewOutput {
    
    func setPasswordView(in stackView: UIStackView) -> PasswordContainerView  {
        let passView = PasswordContainerView.create(in: stackView, digit: kPasswordDigits)
        passView.delegate = self
        passView.tintColor = UIColor.mainBlue
        passView.highlightedColor = UIColor.mainBlue
        passView.touchAuthenticationEnabled = interactor.isBiometryAuthEnabled()
        return passView
    }

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func inputComplete(_ password: String) {
        interactor.validatePassword(password)
    }
    
    func showAuthorizationZone() {
        router.showMainTabBar()
    }

    func iForgotPinPressed() {
        //TODO: message, localization
        
        let alertController = UIAlertController(title: nil, message: "Do you want to reset your pin?", preferredStyle: .actionSheet)
        
        let resetPin = UIAlertAction(title: "Reset pin", style: .default, handler: { [weak self] (alert: UIAlertAction) -> Void in
            self?.interactor.resetPin()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(resetPin)
        alertController.addAction(cancelAction)
        
        view.presentAlertController(alertController)
        
    }
    
}


// MARK: - PinInputInteractorOutput

extension PinInputPresenter: PinInputInteractorOutput {
    
    func passwordIsCorrect() {
        view.inputSucceed()
    }
    
    func passwordIsWrong() {
        view.inputFailed()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    func pinWasReset() {
        router.showLogin()
    }
    
}


// MARK: - PinInputModuleInput

extension PinInputPresenter: PinInputModuleInput {
    func present() {
        view.present()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PinInputCompleteProtocol
extension PinInputPresenter: PinInputCompleteProtocol {
    func pinInputComplete(input: String) {
        interactor.validatePassword(input)
    }
    
    func touchAuthenticationComplete(success: Bool, error: String?) {
        if success {
            view.inputSucceed()
        } else {
            view.clearInput()
            if let error = error {
                log.warn(error)
                
                //TODO: debug
                view.showAlert(title: "Touch ID failed", message: error)
            }
        }
    }
}



