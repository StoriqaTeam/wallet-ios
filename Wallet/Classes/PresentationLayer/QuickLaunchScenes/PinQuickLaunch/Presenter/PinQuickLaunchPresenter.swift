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
    
}


// MARK: - PinQuickLaunchInteractorOutput

extension PinQuickLaunchPresenter: PinQuickLaunchInteractorOutput {
    
}


// MARK: - PinQuickLaunchModuleInput

extension PinQuickLaunchPresenter: PinQuickLaunchModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
    
}
