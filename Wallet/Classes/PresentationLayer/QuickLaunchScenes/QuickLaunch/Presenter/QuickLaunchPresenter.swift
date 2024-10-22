//
//  QuickLaunchPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QuickLaunchPresenter {
    
    weak var view: QuickLaunchViewInput!
    weak var output: QuickLaunchModuleOutput?
    var interactor: QuickLaunchInteractorInput!
    var router: QuickLaunchRouterInput!
    
    private let baseFadeAnimator: BaseFadeAnimator
    
    init(baseFadeAnimator: BaseFadeAnimator) {
        self.baseFadeAnimator = baseFadeAnimator
    }
}


// MARK: - QuickLaunchViewOutput

extension QuickLaunchPresenter: QuickLaunchViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }

    func performAction() {
        router.showPinQuickLaunch(qiuckLaunchProvider: interactor.getProvider(),
                                  from: view.viewController,
                                  baseFadeAnimator: baseFadeAnimator)
    }
    
}


// MARK: - QuickLaunchInteractorOutput

extension QuickLaunchPresenter: QuickLaunchInteractorOutput {
    
}


// MARK: - QuickLaunchModuleInput

extension QuickLaunchPresenter: QuickLaunchModuleInput {
    func presentAsTansitioningNavigationController() {
        view.presentAsTransitioningNavController()
    }
}
