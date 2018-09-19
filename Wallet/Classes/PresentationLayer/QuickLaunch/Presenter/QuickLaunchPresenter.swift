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
 
    let screenApperance: QuickLaunchScreenApperance
    
    init(screenApperance: QuickLaunchScreenApperance) {
        self.screenApperance = screenApperance
    }
    
}


// MARK: - QuickLaunchViewOutput

extension QuickLaunchPresenter: QuickLaunchViewOutput {

    func viewIsReady() {
        view.setupInitialState(screenApperance: screenApperance)
    }

}


// MARK: - QuickLaunchInteractorOutput

extension QuickLaunchPresenter: QuickLaunchInteractorOutput {

}


// MARK: - QuickLaunchModuleInput

extension QuickLaunchPresenter: QuickLaunchModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
