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
    
    private var storiqaLoader: StoriqaLoader!
}


// MARK: - ConnectPhoneViewOutput

extension ConnectPhonePresenter: ConnectPhoneViewOutput {

    func viewIsReady() {
        let phone: String = {
            let userPhone = interactor.getUserPhone()
            if userPhone.isEmpty || userPhone.hasPrefix("+") {
                return userPhone
            }
            
            return "+" + userPhone
        }()
        
        let button = phone.isEmpty ? "Connect" : "Change"
        let title = button + " phone number"
        
        view.setupInitialState(phone: phone, buttonTitle: button)
        configureNavigationBar(title: title)
        view.setConnectButtonEnabled(false)
        addLoader()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkNavigationBarButtons()
    }
    
    func phoneChanged(_ phone: String) {
        view.setConnectButtonEnabled(phone.isValidPhone(hasPlusPrefix: true))
    }

    func isValidPhoneNumber(_ phone: String) -> Bool {
        return phone.isValidPhone(hasPlusPrefix: true, unfinished: true)
    }
    
    func connectButtonPressed(_ phone: String) {
        storiqaLoader.startLoader()
        interactor.updateUserPhone(phone.clearedPhoneNumber())
    }
    
    func cancelButtonPressed() {
        view.dismiss()
    }
    
}


// MARK: - ConnectPhoneInteractorOutput

extension ConnectPhonePresenter: ConnectPhoneInteractorOutput {
    func userUpdatedSuccessfully() {
        storiqaLoader.stopLoader()
        view.dismiss()
    }
    
    func userUpdateFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, from: view.viewController)
    }
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
    
    private func addLoader() {
        guard let parentView = view.viewController.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
