//
//  FirstLaunchFirstLaunchPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class FirstLaunchPresenter {
    
    weak var view: FirstLaunchViewInput!
    weak var output: FirstLaunchModuleOutput?
    var interactor: FirstLaunchInteractorInput!
    var router: FirstLaunchRouterInput!
    
}


// MARK: - FirstLaunchViewOutput

extension FirstLaunchPresenter: FirstLaunchViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func showRegistration() {
        router.showRegistration()
    }

    func showLogin() {
        router.showLogin()
    }
    
}


// MARK: - FirstLaunchInteractorOutput

extension FirstLaunchPresenter: FirstLaunchInteractorOutput {
    
}


// MARK: - FirstLaunchModuleInput

extension FirstLaunchPresenter: FirstLaunchModuleInput {
    
    func present() {
        view.present()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
