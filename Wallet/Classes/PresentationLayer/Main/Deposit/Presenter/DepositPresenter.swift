//
//  DepositPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositPresenter {
    
    weak var view: DepositViewInput!
    weak var output: DepositModuleOutput?
    var interactor: DepositInteractorInput!
    var router: DepositRouterInput!
    
}


// MARK: - DepositViewOutput

extension DepositPresenter: DepositViewOutput {

    func viewIsReady() {
        view.setupInitialState()
    }

}


// MARK: - DepositInteractorOutput

extension DepositPresenter: DepositInteractorOutput {

}


// MARK: - DepositModuleInput

extension DepositPresenter: DepositModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
