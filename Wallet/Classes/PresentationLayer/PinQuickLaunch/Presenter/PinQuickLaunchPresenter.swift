//
//  PinQuickLaunchPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinQuickLaunchPresenter {
    
    weak var view: PinQuickLaunchViewInput!
    weak var output: PinQuickLaunchModuleOutput?
    var interactor: PinQuickLaunchInteractorInput!
    var router: PinQuickLaunchRouterInput!
    
}


// MARK: - PinQuickLaunchViewOutput

extension PinQuickLaunchPresenter: PinQuickLaunchViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func performAction() {
        router.showPinSetup(qiuckLaunchProvider: interactor.getProvider(), from: view.viewController)
    }
    
    func cancelSetup() {
        interactor.cancelSetup()
    }
    
}


// MARK: - PinQuickLaunchInteractorOutput

extension PinQuickLaunchPresenter: PinQuickLaunchInteractorOutput {
    
    func showAuthorizedZone() {
        router.showAuthorizedZone()
    }
    
    func showBiometryQuickSetup(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        router.showBiometryQuickLaunch(qiuckLaunchProvider: qiuckLaunchProvider, from: view.viewController)
    }
    
}


// MARK: - PinQuickLaunchModuleInput

extension PinQuickLaunchPresenter: PinQuickLaunchModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
    
}
