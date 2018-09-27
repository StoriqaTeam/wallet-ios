//
//  ExchangePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangePresenter {
    
    weak var view: ExchangeViewInput!
    weak var output: ExchangeModuleOutput?
    var interactor: ExchangeInteractorInput!
    var router: ExchangeRouterInput!
    
}


// MARK: - ExchangeViewOutput

extension ExchangePresenter: ExchangeViewOutput {
    func configureCollections() {
        interactor.scrollCollection()
    }
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
        interactor.setAccountsDataManagerDelegate(self)
        interactor.setWalletsDataManagerDelegate(self)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createAccountsDataManager(with: collectionView)
    }
    
    func walletsTableView(_ tableView: UITableView) {
        interactor.createWalletsDataManager(with: tableView)
    }

}


// MARK: - ExchangeInteractorOutput

extension ExchangePresenter: ExchangeInteractorOutput {

}


// MARK: - ExchangeModuleInput

extension ExchangePresenter: ExchangeModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }

    func present() {
        view.present()
    }
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - AccountsDataManagerDelegate

extension ExchangePresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        view.setNewPage(newIndex)
    }
}


// MARK: - WalletsDataManagerDelegate

extension ExchangePresenter: WalletsDataManagerDelegate {
    func chooseWallet() {
        view.viewController.showAlert(title: "", message: "User choose wallet")
    }
}


// MARK: - Private methods

extension ExchangePresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let spacing: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if Device.isSmallScreen {
            width = 280
            height = 165
        } else {
            width = 336
            height = 198
        }
        spacing = (Constants.Sizes.screenWith - width) / 4
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, spacing * 2, 0, spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkTextNavigationBar()
        view.viewController.navigationController?.navigationBar.topItem?.title = "Exchange"
    }

}
