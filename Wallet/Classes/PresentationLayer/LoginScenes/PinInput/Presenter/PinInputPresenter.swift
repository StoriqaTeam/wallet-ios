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
    private var isPresentedModally = false
    
}


// MARK: - PinInputViewOutput

extension PinInputPresenter: PinInputViewOutput {
    
    func pinContainer(_ pinContainer: PinContainerView) {
        pinContainer.delegate = self
        pinContainer.totalDotCount = kPasswordDigits
        pinContainer.tintColor = Theme.Color.brightSkyBlue
        pinContainer.highlightedColor = Theme.Color.brightSkyBlue
        pinContainer.touchAuthenticationEnabled = interactor.isBiometryAuthEnabled()
        pinContainer.authButtonImage = interactor.biometricAuthImage()
    }

    func viewIsReady() {
        let user = interactor.getCurrentUser()
        let userPhoto = user.photo ?? #imageLiteral(resourceName: "profilePhotoPlaceholder")
        view.setupInitialState(userPhoto: userPhoto, userName: user.firstName)
    }
    
    func inputComplete(_ password: String) {
        interactor.validatePassword(password)
    }

    func iForgotPinPressed() {
        //TODO: message, localization
        
        let alertController = UIAlertController(title: nil, message: "Do you want to reset your pin?", preferredStyle: .actionSheet)
        
        let resetPin = UIAlertAction(title: "Reset pin", style: .default, handler: { [weak self] _ -> Void in
            guard let strongSelf = self else { return }
            
            if strongSelf.isPresentedModally {
                strongSelf.view.dismissModal { [weak strongSelf] in
                    
                    strongSelf?.interactor.resetPin()
                    strongSelf?.router.showLogin()
                }
            } else {
                strongSelf.interactor.resetPin()
                strongSelf.router.showLogin()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(resetPin)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = Theme.Color.brightSkyBlue
        
        view.viewController.present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - PinInputInteractorOutput

extension PinInputPresenter: PinInputInteractorOutput {
    
    func passwordIsCorrect() {
        view.inputSucceed()
        
        if isPresentedModally {
            view.dismissModal()
        } else {
            router.showMainTabBar()
        }
    }
    
    func passwordIsWrong() {
        view.inputFailed()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func touchAuthenticationSucceed() {
        view.inputSucceed()
        
        if isPresentedModally {
            view.dismissModal()
        } else {
            router.showMainTabBar()
        }
    }
    
    func touchAuthenticationFailed(error: String) {
        view.clearInput()
        
        if !error.isEmpty {
            log.warn(error)
            view.showAlert(title: "Touch ID failed", message: error)
        }
    }
    
}


// MARK: - PinInputModuleInput

extension PinInputPresenter: PinInputModuleInput {
    func present() {
        isPresentedModally = false
        view.present()
    }

    func present(from viewController: UIViewController) {
        isPresentedModally = false
        view.present(from: viewController)
    }
    
    func presentModal(from viewController: UIViewController) {
        isPresentedModally = true
        view.viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        view.presentModal(from: viewController)
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
