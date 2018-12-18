//
//  RecepientAccountsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RecepientAccountsPresenter {
    
    weak var view: RecepientAccountsViewInput!
    weak var output: RecepientAccountsModuleOutput?
    var interactor: RecepientAccountsInteractorInput!
    var router: RecepientAccountsRouterInput!
    
    
    private let accountDisplayer: AccountDisplayerProtocol
    private var dataManager: MyWalletDataManager!
    
    init(accountDisplayer: AccountDisplayerProtocol) {
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - RecepientAccountsViewOutput

extension RecepientAccountsPresenter: RecepientAccountsViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkNavigationBarButtons()
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = MyWalletDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        
        accountsManager.setCollectionView(collectionView, cellType: .small)
        dataManager = accountsManager
        dataManager.delegate = self
    }

}


// MARK: - RecepientAccountsInteractorOutput

extension RecepientAccountsPresenter: RecepientAccountsInteractorOutput {

}


// MARK: - MyWalletViewOutput

extension RecepientAccountsPresenter: MyWalletDataManagerDelegate {
    
    func snapshotOfSelectedItem(_ snapshot: UIView) { }

    func didChangeOffset(_ newValue: CGFloat) { }
    
    func selectAccount(_ account: Account) {
        interactor.setSelected(account: account)
        view.dismiss()
    }
    
}


// MARK: - RecepientAccountsModuleInput

extension RecepientAccountsPresenter: RecepientAccountsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}

// MARK: - Private methods

extension RecepientAccountsPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .verticalSmall)
        return deviceLayout
    }
    
    private func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: "Choose account")
    }
    
}
