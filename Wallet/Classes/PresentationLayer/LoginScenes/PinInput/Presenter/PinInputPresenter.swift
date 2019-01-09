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
    
    typealias LocalizedString = Strings.PinInput
    
    weak var view: PinInputViewInput!
    weak var output: PinInputModuleOutput?
    var interactor: PinInputInteractorInput!
    var router: PinInputRouterInput!
    
    private let kPasswordDigits = 4
    private var isPresentedModally = false
    private var isBiometryAuthShown = false
    
    deinit {
        unsubscribeFromNotification()
    }
}


// MARK: - PinInputViewOutput

extension PinInputPresenter: PinInputViewOutput {
    
    func pinContainer(_ pinContainer: PinContainerView) {
        pinContainer.delegate = self
        pinContainer.tintColor = Theme.Color.Text.main
        pinContainer.highlightedColor = Theme.Color.Text.main.withAlphaComponent(0.1)
        pinContainer.unhighlightedColor = Theme.Color.Text.main.withAlphaComponent(0.2)
        pinContainer.textFont = Theme.Font.PinInput.number
        pinContainer.borderWidth = 0
        pinContainer.dotStrokeColor = .clear
        pinContainer.touchAuthenticationEnabled = interactor.isBiometryAuthEnabled()
        pinContainer.authButtonImage = interactor.biometricAuthImage()
    }

    func viewIsReady() {
        let user = interactor.getCurrentUser()
        let userPhoto = user.photo ?? #imageLiteral(resourceName: "profilePhotoPlaceholder")
        view.setupInitialState(userPhoto: userPhoto, userName: user.firstName)
        interactor.setIsLocked()
        subscribeForNotification()
    }
    
    func viewDidAppear() {
        authWithBiometry(delay: 0)
    }
    
    
    func inputComplete(_ password: String) {
        interactor.validatePassword(password)
    }

    func iForgotPinPressed() {
        let alertController = UIAlertController(title: nil,
                                                message: LocalizedString.confirmPinResetMessage,
                                                preferredStyle: .actionSheet)
        
        let resetPin = UIAlertAction(title: LocalizedString.resetPinAlertAction,
                                     style: .default,
                                     handler: { [weak self] _ -> Void in
                                        
            guard let strongSelf = self else { return }
            strongSelf.unsubscribeFromNotification()
            
            let completion = { [weak strongSelf] in
                strongSelf?.interactor.resetPin()
                strongSelf?.router.showLogin()
            }
            
            if strongSelf.isPresentedModally {
                strongSelf.view.dismissModal(animated: false, completion: completion)
            } else {
                completion()
            }
        })
        
        let cancelAction = UIAlertAction(title: LocalizedString.cancelAlertAction, style: .cancel)
        
        alertController.addAction(resetPin)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = Theme.Color.mainOrange
        
        view.viewController.present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - PinInputInteractorOutput

extension PinInputPresenter: PinInputInteractorOutput {
    
    func passwordIsCorrect() {
        view.inputSucceed()
        unsubscribeFromNotification()
        
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
        isBiometryAuthShown = false
        view.inputSucceed()
        
        if isPresentedModally {
            view.dismissModal()
        } else {
            router.showMainTabBar()
        }
    }
    
    func touchAuthenticationFailed(error: String) {
        isBiometryAuthShown = false
        view.clearInput()
        
        if !error.isEmpty {
            log.warn(error)
            view.showAlert(title: LocalizedString.touchIdFailedMessage, message: error)
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
        isBiometryAuthShown = true
        interactor.authWithBiometry()
    }
    
}


// MARK: - Private methods
extension PinInputPresenter {
    private func subscribeForNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(authWithBiometry),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    private func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc private func authWithBiometry(delay: TimeInterval = 0.35) {
        guard !isBiometryAuthShown && interactor.isBiometryAuthEnabled() else {
            return
        }
        
        isBiometryAuthShown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.interactor.authWithBiometry()
        }
    }
}
