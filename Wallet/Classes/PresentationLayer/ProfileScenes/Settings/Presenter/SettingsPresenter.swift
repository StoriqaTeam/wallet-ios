//
//  SettingsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsPresenter {
    
    weak var view: SettingsViewInput!
    weak var output: SettingsModuleOutput?
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!
    
}


// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
    }
    
    func viewWillAppear() {
        let hasPhone = interactor.userHasPhone()
        let title = (hasPhone ? "Change" : "Connect") + " telephone number"
        view.setChangePhoneTitle(title)
    }
    
    func editProfileSelected() {
        router.showEditProfile(from: view.viewController)
    }
    
    func changePasswordSelected() {
        router.showChangePassword(from: view.viewController)
    }
    
    func changePhoneNumber() {
        router.showChangePhone(from: view.viewController)
    }
    
    func signOutButtonTapped() {
        router.signOutConfirmPopUp(popUpDelegate: self, from: view.viewController)
    }
    
}


// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {

}


// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PopUpSignOutVMDelegate

extension SettingsPresenter: PopUpSignOutVMDelegate {
    func signOut() {
        interactor.deleteAppData()
        router.signOut()
    }
}


// MARK: - Private methods

extension SettingsPresenter {
    func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: "Settings")
    }
}
