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
        view.viewController.setDarkNavigationBarButtons()
        view.setSessions(count: sessionsCount)
    }
    
    func willMoveToParentVC() {
        guard let navigationBar = view.viewController.navigationController?.navigationBar else {
            return
        }
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.backgroundColor = .clear
    }
    
    func viewDidAppear() {
        guard let navigationBar = view.viewController.navigationController?.navigationBar else {
            return
        }
        
        let rect = CGRect(x: 0, y: -80, width: Constants.Sizes.screenWith, height: 124)
        let image = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor,
                                                    andRect: rect)
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.backgroundColor = .white
    }
    
    func editProfileSelected() {
        router.showEditProfile(from: view.viewController)
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