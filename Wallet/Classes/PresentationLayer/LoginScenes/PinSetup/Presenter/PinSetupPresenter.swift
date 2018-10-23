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
    
    typealias Localized = Strings.PinSetup
    
    weak var view: PinSetupViewInput!
    weak var output: PinSetupModuleOutput?
    var interactor: PinSetupInteractorInput!
    var router: PinSetupRouterInput!
    
    private let kPasswordDigits = 4
    private let firstInputTitle = Localized.enterPinTitle
    private let confirmInputTitle = Localized.confirmPinTitle
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
        pinContainer.tintColor = Theme.Color.brightSkyBlue
        pinContainer.highlightedColor = Theme.Color.brightSkyBlue
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
        view.viewController.showAlert(message: Localized.pinNotMatchAlert)
        
        view.setTitle(title: firstInputTitle)
        view.wrongInput()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
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
