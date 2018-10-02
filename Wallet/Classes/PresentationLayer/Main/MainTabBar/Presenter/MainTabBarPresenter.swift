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
        let module = MyWalletModule.create(tabBar: view.mainTabBar!, accountWatcher: interactor.getAccountWatcher())
        module.output = self
        return module
    }()

    private lazy var sendModule: SendModuleInput = SendModule.create(accountWatcher: interactor.getAccountWatcher())
    private lazy var exchangeModule: ExchangeModuleInput = ExchangeModule.create(accountWatcher: interactor.getAccountWatcher())
    private lazy var depositModule: DepositModuleInput = DepositModule.create(accountWatcher: interactor.getAccountWatcher())
    private lazy var settingsModule: SettingsModuleInput = SettingsModule.create()
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
