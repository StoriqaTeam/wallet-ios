//
//  RecipientAccountsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RecipientAccountsPresenter {
    typealias LocalizedStrings = Strings.RecipientAccounts
    
    weak var view: RecipientAccountsViewInput!
    weak var output: RecipientAccountsModuleOutput?
    var interactor: RecipientAccountsInteractorInput!
    var router: RecipientAccountsRouterInput!
    
    
    private let accountDisplayer: AccountDisplayerProtocol
    private var dataManager: MyWalletDataManager!
    
    init(accountDisplayer: AccountDisplayerProtocol) {
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - RecipientAccountsViewOutput

extension RecipientAccountsPresenter: RecipientAccountsViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
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


// MARK: - RecipientAccountsInteractorOutput

extension RecipientAccountsPresenter: RecipientAccountsInteractorOutput {

}


// MARK: - MyWalletViewOutput

extension RecipientAccountsPresenter: MyWalletDataManagerDelegate {
    
    func snapshotsForTransition(snapshots: [UIView], selectedIndex: Int) { }

    func didChangeOffset(_ newValue: CGFloat) { }
    
    func selectAccount(_ account: Account) {
        interactor.setSelected(account: account)
        view.dismiss()
    }
    
    func addNewAccountButtonTapped() { }
}


// MARK: - RecipientAccountsModuleInput

extension RecipientAccountsPresenter: RecipientAccountsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}

// MARK: - Private methods

extension RecipientAccountsPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .verticalSmall)
        return deviceLayout
    }
    
    private func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = LocalizedStrings.navigationTitle
    }
    
}
