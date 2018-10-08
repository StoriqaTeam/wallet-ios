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
    
    func viewIsReady() {
        view.setupInitialState(flowLayout: collectionFlowLayout)
        interactor.setDataManagerDelegate(self)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createDataManager(with: collectionView)
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
                                tabBar: mainTabBar)
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
}
