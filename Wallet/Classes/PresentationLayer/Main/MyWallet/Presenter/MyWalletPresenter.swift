//
//  MyWalletPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MyWalletPresenter {
    
    weak var view: MyWalletViewInput!
    weak var output: MyWalletModuleOutput?
    var interactor: MyWalletInteractorInput!
    var router: MyWalletRouterInput!
    weak var mainTabBar: UITabBarController!
    
    private let user: User
    private let accountDisplayer: AccountDisplayerProtocol
    private var dataManager: MyWalletDataManager!
    
    init(user: User,
         accountDisplayer: AccountDisplayerProtocol) {
        self.user = user
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = MyWalletDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView)
        dataManager = accountsManager
        dataManager.delegate = self
    }
    
    func addNewTapped() {
        // TODO: addNewTapped
    }
    
}


// MARK: - MyWalletInteractorOutput

extension MyWalletPresenter: MyWalletInteractorOutput {

}


// MARK: - MyWalletModuleInput

extension MyWalletPresenter: MyWalletModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
    

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletDataManagerDelegate {
    
    func selectAccount(_ account: Account) {
        let accountWatcher = interactor.getAccountWatcher()
        accountWatcher.setAccount(account)
        router.showAccountsWith(accountWatcher: accountWatcher,
                                from: view.viewController,
                                tabBar: mainTabBar,
                                user: user)
    }
    
}


// MARK: - Private methods

extension MyWalletPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.myWalletCollectionFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.minimumInteritemSpacing = deviceLayout.spacing
        flowLayout.sectionInset = UIEdgeInsets(top: deviceLayout.spacing,
                                               left: 0,
                                               bottom: deviceLayout.spacing,
                                               right: 0)
        flowLayout.itemSize = deviceLayout.size
        
        return flowLayout
    }
    
    private func configureNavigationBar() {
        guard let navBar = view.viewController.navigationController else { return }

        view.viewController.setWhiteTextNavigationBar()
        navBar.navigationBar.prefersLargeTitles = true
        navBar.navigationBar.isTranslucent = true
        navBar.navigationBar.topItem?.title = "my_wallet".localized()
    }
}
