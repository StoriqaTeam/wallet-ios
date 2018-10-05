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
    
    func pinContainer(_ pinContainer: PinContainerView) {
        pinContainer.delegate = self
        pinContainer.totalDotCount = kPasswordDigits
        pinContainer.tintColor = UIColor.mainBlue
        pinContainer.highlightedColor = UIColor.mainBlue
        pinContainer.touchAuthenticationEnabled = interactor.isBiometryAuthEnabled()
        pinContainer.authButtonImage = interactor.biometricAuthImage()
    }

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func inputComplete(_ password: String) {
        interactor.validatePassword(password)
    }

    func iForgotPinPressed() {
        //TODO: message, localization
        
        let alertController = UIAlertController(title: nil, message: "Do you want to reset your pin?", preferredStyle: .actionSheet)
        
        let resetPin = UIAlertAction(title: "Reset pin", style: .default, handler: { [weak self] _ -> Void in
            self?.interactor.resetPin()
            self?.router.showLogin()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(resetPin)
        alertController.addAction(cancelAction)
        
        view.viewController.present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - PinInputInteractorOutput

extension PinInputPresenter: PinInputInteractorOutput {
    
    func passwordIsCorrect() {
        view.inputSucceed()
        router.showMainTabBar()
    }
    
    func passwordIsWrong() {
        view.inputFailed()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func touchAuthenticationSucceed() {
        view.inputSucceed()
        router.showMainTabBar()
    }
    
    func touchAuthenticationFailed(error: String?) {
        view.clearInput()
        
        if let error = error {
            log.warn(error)
            
            //TODO: debug
            view.showAlert(title: "Touch ID failed", message: error)
        }
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
    
    func authWithBiometryTapped() {
        interactor.authWithBiometry()
    }
    
}
