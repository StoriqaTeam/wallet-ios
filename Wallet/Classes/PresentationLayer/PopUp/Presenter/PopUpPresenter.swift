//
//  PopUpPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PopUpPresenter {
    
    weak var view: PopUpViewInput!
    weak var output: PopUpModuleOutput?
    var interactor: PopUpInteractorInput!
    var router: PopUpRouterInput!
    
}


// MARK: - PopUpViewOutput

extension PopUpPresenter: PopUpViewOutput {

    func viewIsReady() {
        let vm = interactor.getViewModel()
        view.setupInitialState(vm: vm)
    }

}


// MARK: - PopUpInteractorOutput

extension PopUpPresenter: PopUpInteractorOutput {

}


// MARK: - PopUpModuleInput

extension PopUpPresenter: PopUpModuleInput {

    func present(from viewController: UIViewController) {
        view.viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        view.presentModal(from: viewController)
    }
}
