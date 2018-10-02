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
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletViewOutput {
    func selectItemAt(index: Int) {
        let selectedAccount = interactor.accountModel(for: index)
        let accountWatcher = interactor.getAccountWatcher()
        accountWatcher.setAccount(selectedAccount)
        router.showAccountsWith(accountWatcher: accountWatcher,
                                from: view.viewController,
                                tabBar: mainTabBar)
    }
    
    
    func viewIsReady() {
        view.setupInitialState(flowLayout: collectionFlowLayout)
    }
    
    func accountsCount() -> Int {
        return interactor.accountsCount()
    }

    func accountModel(for indexPath: IndexPath)  -> Account {
        let account = interactor.accountModel(for: indexPath.row)
        return account
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


// MARK: - Private methods

extension MyWalletPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.myWalletCollectionFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.minimumInteritemSpacing = deviceLayout.spacing
        flowLayout.sectionInset = UIEdgeInsetsMake(deviceLayout.spacing, 0, deviceLayout.spacing, 0)
        flowLayout.itemSize = deviceLayout.size
        
        return flowLayout
    }
}
