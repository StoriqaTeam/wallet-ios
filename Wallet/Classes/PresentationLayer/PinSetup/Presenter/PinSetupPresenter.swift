//
//  PinSetupPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AudioToolbox


class PinSetupPresenter {
    
    weak var view: PinSetupViewInput!
    weak var output: PinSetupModuleOutput?
    var interactor: PinSetupInteractorInput!
    var router: PinSetupRouterInput!
    
    private let kPasswordDigits = 4
    private let firstInputTitle = "enter_pin".localized()
    private let confirmInputTitle = "confirm_pin".localized()
}


// MARK: - PinSetupViewOutput

extension PinSetupPresenter: PinSetupViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        view.setTitle(title: firstInputTitle)
    }
    
    func setPasswordView(in stackView: UIStackView) -> PasswordContainerView  {
        //TODO: remove hardcode
        let passView = PasswordContainerView.create(in: stackView, digit: kPasswordDigits, defaultHeight: 450)
        passView.delegate = self
        passView.touchAuthenticationEnabled = false
        passView.tintColor = UIColor.mainBlue
        passView.highlightedColor = UIColor.mainBlue
        return passView
    }

}


// MARK: - PinSetupInteractorOutput

extension PinSetupPresenter: PinSetupInteractorOutput {
    
    func showAuthorizedZone() {
        view.viewController.showAlert(message: "Далее приложение должно перейти в авторизованную зону")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            LoginModule.create().present()
        }
        router.showAuthorizedZone()
    }
    
    func showBiometryQuickSetup(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        router.showBiometryQuickLaunch(qiuckLaunchProvider: qiuckLaunchProvider, from: view.viewController)
    }
    
    func enterConfirmationPin() {
        view.setTitle(title: confirmInputTitle)
        view.clearInput()
    }
    
    func enterPinAgain() {
        view.viewController.showAlert(message: "pins_not_match_alert".localized())
        
        view.setTitle(title: firstInputTitle)
        view.wrongInput()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}


// MARK: - PinSetupModuleInput

extension PinSetupPresenter: PinSetupModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PasswordInputCompleteProtocol
extension PinSetupPresenter: PasswordInputCompleteProtocol {
    func passwordInputComplete(input: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.interactor.pinInputCompleted(input)
        }
    }
    
    func touchAuthenticationComplete(success: Bool, error: String?) { }
}
