//
//  MainTabBarPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MainTabBarPresenter {
    
    weak var view: MainTabBarViewInput!
    weak var output: MainTabBarModuleOutput?
    var interactor: MainTabBarInteractorInput!
    var router: MainTabBarRouterInput!
    
    private lazy var myWalletModule: MyWalletModuleInput = {
        let watcher = interactor.getAccountWatcher()
        let user = interactor.getCurrentUser()
        let app = interactor.getApplication()
        let module = MyWalletModule.create(app: app, tabBar: view.mainTabBar!, accountWatcher: watcher, user: user)
        module.output = self
        return module
    }()

    private lazy var sendModule: SendModuleInput = {
        let watcher = interactor.getAccountWatcher()
        let user = interactor.getCurrentUser()
        let app = interactor.getApplication()
        return SendModule.create(app: app, accountWatcher: watcher, user: user, tabBar: view.mainTabBar!)
    }()
    
    private lazy var exchangeModule: ExchangeModuleInput = {
        let watcher = interactor.getAccountWatcher()
        let user = interactor.getCurrentUser()
        let app = interactor.getApplication()
        return ExchangeModule.create(app: app, accountWatcher: watcher, user: user)
    }()
    
    private lazy var depositModule: DepositModuleInput = {
        let watcher = interactor.getAccountWatcher()
        let user = interactor.getCurrentUser()
        let app = interactor.getApplication()
        return DepositModule.create(app: app, accountWatcher: watcher, user: user)
    }()
    
    private lazy var settingsModule: SettingsModuleInput = SettingsModule.create(app: interactor.getApplication())
    
}


// MARK: - MainTabBarViewOutput

extension MainTabBarPresenter: MainTabBarViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        insertViewControllers()
    }

}


// MARK: - MainTabBarInteractorOutput

extension MainTabBarPresenter: MainTabBarInteractorOutput {
    
}


// MARK: - MainTabBarModuleInput

extension MainTabBarPresenter: MainTabBarModuleInput {
    func present() {
        view.present()
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - MyWalletModuleOuput

extension MainTabBarPresenter: MyWalletModuleOutput {
    
}


// MARK: - Private methods

extension MainTabBarPresenter {
    private func insertViewControllers() {
        view.viewControllers = [
            myWalletModule.viewController.wrapToNavigationController(),
            sendModule.viewController.wrapToNavigationController(),
            exchangeModule.viewController.wrapToNavigationController(),
            depositModule.viewController.wrapToNavigationController(),
            settingsModule.viewController.wrapToNavigationController()
        ]
    }
}
