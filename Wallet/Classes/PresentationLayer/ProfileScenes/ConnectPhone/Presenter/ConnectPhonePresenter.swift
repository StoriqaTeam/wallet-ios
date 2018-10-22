//
//  ConnectPhonePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ConnectPhonePresenter {
    
    weak var view: ConnectPhoneViewInput!
    weak var output: ConnectPhoneModuleOutput?
    var interactor: ConnectPhoneInteractorInput!
    var router: ConnectPhoneRouterInput!
    
}


// MARK: - ConnectPhoneViewOutput

extension ConnectPhonePresenter: ConnectPhoneViewOutput {

    func viewIsReady() {
        let phone = interactor.getUserPhone()
        let button = phone.isEmpty ? "Connect" : "Change"
        let title = button + " telephone number"
        
        view.setupInitialState(phone: phone, buttonTitle: button)
        configureNavigationBar(title: title)
        view.setConnectButtonEnabled(false)
    }
    
    func viewWillAppear() {
        view.viewController.setDarkNavigationBarButtons()
    }

    func isValidPhoneNumber(_ phone: String) -> Bool {
        view.setConnectButtonEnabled(phone.isValidPhone(hasPlusPrefix: true))
        return phone.isValidPhone(hasPlusPrefix: true, unfinished: true)
    }
    
    func connectButtonPressed(_ phone: String) {
        interactor.updateUserPhone(phone)
        view.dismiss()
    }
    
    func cancelButtonPressed() {
        view.dismiss()
    }
    
}


// MARK: - ConnectPhoneInteractorOutput

extension ConnectPhonePresenter: ConnectPhoneInteractorOutput {

}


// MARK: - ConnectPhoneModuleInput

extension ConnectPhonePresenter: ConnectPhoneModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private methods

extension ConnectPhonePresenter {
    
    private func configureNavigationBar(title: String) {
        view.viewController.setDarkNavigationBar(title: title)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
    }
    
}
