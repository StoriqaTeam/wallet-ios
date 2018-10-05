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
    
    func pinContainer(_ pinContainer: PinContainerView) {
        pinContainer.delegate = self
        pinContainer.totalDotCount = kPasswordDigits
        pinContainer.touchAuthenticationEnabled = false
        pinContainer.tintColor = UIColor.mainBlue
        pinContainer.highlightedColor = UIColor.mainBlue
    }

}


// MARK: - PinSetupInteractorOutput

extension PinSetupPresenter: PinSetupInteractorOutput {
    
    func showAuthorizedZone() {
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


// MARK: - PinInputCompleteProtocol
extension PinSetupPresenter: PinInputCompleteProtocol {
    func authWithBiometryTapped() {
        // No biometry auth in setup
    }
    
    func pinInputComplete(input: String) {
        interactor.pinInputCompleted(input)
    }
}
