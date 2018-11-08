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
    func sessionSelected() {
        router.showSessions(from: view.viewController)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
    }
    
    func viewWillAppear() {
        let sessionsCount = interactor.getSessionsCount()
        view.setSessions(count: sessionsCount)
    }
    
    func myProfileSelected() {
        router.showProfile(from: view.viewController)
    }
    
    func changePhoneSelected() {
        router.showChangePhone(from: view.viewController)
    }
    
    func changePasswordSelected() {
        router.showChangePassword(from: view.viewController)
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


// MARK: - Private methods

extension SettingsPresenter {
    func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: "Settings")
    }
}
