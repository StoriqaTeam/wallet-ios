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
    
    private var pinSetupDataManager: PinSetupDataManager!
    
    private let firstInputTitle = "enter_pin".localized()
    private let confirmInputTitle = "confirm_pin".localized()
}


// MARK: - PinSetupViewOutput

extension PinSetupPresenter: PinSetupViewOutput {
    func pinSetupCollectionView(_ view: UICollectionView) {
        let dataManager = PinSetupDataManager()
        dataManager.setCollectionView(view)
        pinSetupDataManager = dataManager
        pinSetupDataManager.delegate = self
    }
    

    func viewIsReady() {
        view.setupInitialState()
        view.setTitle(title: firstInputTitle)
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
        pinSetupDataManager.scrollTo(state: .confirmPin)
    }
    
    func enterPinAgain() {
        view.viewController.showAlert(message: "pins_not_match_alert".localized())
        
        view.setTitle(title: firstInputTitle)
        pinSetupDataManager.scrollTo(state: .setPin)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}


// MARK: PinSetupdataManagerDelegate

extension PinSetupPresenter: PinSetupDataManagerDelegate {
    func pinSet(input: String) {
        interactor.pinInputCompleted(input)
    }
}


// MARK: - PinSetupModuleInput

extension PinSetupPresenter: PinSetupModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
