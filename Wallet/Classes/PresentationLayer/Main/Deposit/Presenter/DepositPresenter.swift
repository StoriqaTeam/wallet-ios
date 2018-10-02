//
//  DepositPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositPresenter {
    
    weak var view: DepositViewInput!
    weak var output: DepositModuleOutput?
    var interactor: DepositInteractorInput!
    var router: DepositRouterInput!
    
}


// MARK: - DepositViewOutput

extension DepositPresenter: DepositViewOutput {
    func copyButtonPressed() {
        let address = interactor.getaAddress()
        UIPasteboard.general.string = address
        
        //TODO: show user that address was copied?
    }
    
    func shareButtonPressed() {
        let qrCodeImage = interactor.getQrCodeImage()
        let shareVC = UIActivityViewController(activityItems: [qrCodeImage], applicationActivities: nil)
        view.viewController.present(shareVC, animated: true, completion: nil)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createAccountsDataManager(with: collectionView)
    }
    
    func configureCollections() {
        interactor.scrollCollection()
    }

    func viewIsReady() {
        configureNavBar()
        interactor.setAccountsDataManagerDelegate(self)
        
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        
        let address = interactor.getaAddress()
        view.setAddress(address)
        
        let qrCode = interactor.getQrCodeImage()
        view.setQrCode(qrCode)
    }

}


// MARK: - DepositInteractorOutput

extension DepositPresenter: DepositInteractorOutput {

}


// MARK: - DepositModuleInput

extension DepositPresenter: DepositModuleInput {
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

extension DepositPresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        interactor.setCurrentAccountWith(index: newIndex)
        view.setNewPage(newIndex)
        
        let address = interactor.getaAddress()
        view.setAddress(address)
        
        let qrCode = interactor.getQrCodeImage()
        view.setQrCode(qrCode)
    }
}


// MARK: - Private methods

extension DepositPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.accountsCollectionSmallFlowLayout
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.itemSize = deviceLayout.size
        flowLayout.sectionInset = UIEdgeInsetsMake(0, deviceLayout.spacing * 2, 0, deviceLayout.spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteTextNavigationBar()
        view.viewController.navigationController?.navigationBar.topItem?.title = "Deposit to account"
    }
}
