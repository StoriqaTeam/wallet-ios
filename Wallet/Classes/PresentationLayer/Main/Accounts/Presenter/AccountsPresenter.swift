//
//  AccountsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsPresenter {
    
    weak var view: AccountsViewInput!
    weak var output: AccountsModuleOutput?
    var interactor: AccountsInteractorInput!
    var router: AccountsRouterInput!
    
}


// MARK: - AccountsViewOutput

extension AccountsPresenter: AccountsViewOutput {
    func transactionTableView(_ tableView: UITableView) {
        interactor.createTransactionsDataManager(with: tableView)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createAccountsDataManager(with: collectionView)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        let iso = interactor.getInitialCurrencyISO()
        view.viewController.title = "Account \(iso)"
        interactor.setAccountsDataManagerDelegate(self)
        interactor.setTransactionDataManagerDelegate(self)
    }
}


// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    
}


// MARK: - AccountsModuleInput

extension AccountsPresenter: AccountsModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - AccountsDataManagerDelegate

extension AccountsPresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        view.setNewPage(newIndex)
    }
}


// MARK: - TransactionsDatamanagerDelegate

extension AccountsPresenter: LastTransactionsDataManagerDelegate {
    
}

// MARK: - Private methods

extension AccountsPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let spacing: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if Constants.Sizes.isSmallScreen {
            spacing = 12
            width = Constants.Sizes.screenWith - spacing * 2
            height = width / 1.3//1.7
        } else {
            spacing = 11
            width = 336
            height = 198
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 19, 0, 19)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
}
