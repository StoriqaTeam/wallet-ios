//
//  BiometryQuickLaunchPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class BiometryQuickLaunchPresenter {
    
    weak var view: BiometryQuickLaunchViewInput!
    weak var output: BiometryQuickLaunchModuleOutput?
    var interactor: BiometryQuickLaunchInteractorInput!
    var router: BiometryQuickLaunchRouterInput!
    
}


// MARK: - BiometryQuickLaunchViewOutput

extension BiometryQuickLaunchPresenter: BiometryQuickLaunchViewOutput {

    func viewIsReady() {
        let biometryType = interactor.getBiometryType()
        view.setupInitialState(biometryType: biometryType)
    }

    func performAction() {
        interactor.activateBiometryLogin()
    }
    
    func cancelSetup() {
        router.showAuthorizedZone()
    }
    
}


// MARK: - BiometryQuickLaunchInteractorOutput

extension BiometryQuickLaunchPresenter: BiometryQuickLaunchInteractorOutput {

}


// MARK: - BiometryQuickLaunchModuleInput

extension BiometryQuickLaunchPresenter: BiometryQuickLaunchModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
