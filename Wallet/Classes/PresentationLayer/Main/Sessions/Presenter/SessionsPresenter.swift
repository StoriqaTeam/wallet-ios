//
//  SessionsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsPresenter {
    
    weak var view: SessionsViewInput!
    weak var output: SessionsModuleOutput?
    var interactor: SessionsInteractorInput!
    var router: SessionsRouterInput!
    
}


// MARK: - SessionsViewOutput

extension SessionsPresenter: SessionsViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }

}


// MARK: - SessionsInteractorOutput

extension SessionsPresenter: SessionsInteractorOutput {

}


// MARK: - SessionsModuleInput

extension SessionsPresenter: SessionsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
