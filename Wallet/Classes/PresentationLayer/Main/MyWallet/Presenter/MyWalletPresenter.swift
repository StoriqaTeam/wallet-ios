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
    
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletViewOutput {
    func selectItemAt(index: Int) {
        let selectedAccount = interactor.accountModel(for: index)
        router.showAccountsWith(selectedAccount: selectedAccount, from: view.viewController)
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
        let spacing: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if Constants.Sizes.isSmallScreen {
            spacing = 12
            width = Constants.Sizes.screenWith - spacing * 2
            height = width / 1.7
        } else {
            spacing = 17
            width = 336
            height = 198
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset.top = spacing
        flowLayout.sectionInset.bottom = spacing
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        return flowLayout
    }
}
