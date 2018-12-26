//
//  DepositPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositPresenter {
    
    typealias LocalizedStrings = Strings.Deposit
    
    weak var view: DepositViewInput!
    weak var output: DepositModuleOutput?
    var interactor: DepositInteractorInput!
    var router: DepositRouterInput!
    
    private let accountDisplayer: AccountDisplayerProtocol
    private var accountsDataManager: AccountsDataManager!
    private let depositShortPollingTimer: DepositShortPollingTimerProtocol
    
    init(accountDisplayer: AccountDisplayerProtocol, depositShortPollingTimer: DepositShortPollingTimerProtocol) {
        self.accountDisplayer = accountDisplayer
        self.depositShortPollingTimer = depositShortPollingTimer
    }
}


// MARK: - DepositViewOutput

extension DepositPresenter: DepositViewOutput {
    func copyButtonPressed() {
        let address = interactor.getAddress()
        UIPasteboard.general.string = address
        view.viewController.showAlert(message: LocalizedStrings.addressCopiedMessage)
    }
    
    func shareButtonPressed() {
        let qrCodeImage = interactor.getQrCodeImage()
        let shareVC = UIActivityViewController(activityItems: [qrCodeImage], applicationActivities: nil)
        view.viewController.present(shareVC, animated: true, completion: nil)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView, cellType: .small)
        accountsDataManager = accountsManager
        accountsDataManager.delegate = self
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
    }
    
    func viewIsReady() {
        configureNavBar()
        
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        
        let address = interactor.getAddress()
        view.setAddress(address)
        
        let qrCode = interactor.getQrCodeImage()
        view.setQrCode(qrCode)
        
        interactor.startObservers()
    }
    
    func viewWillAppear() {
        depositShortPollingTimer.startPolling()
    }
    
    func viewWillDisapear() {
        depositShortPollingTimer.invalidate()
    }
}


// MARK: - DepositInteractorOutput

extension DepositPresenter: DepositInteractorOutput {
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
    }
    
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
        
        let address = interactor.getAddress()
        view.setAddress(address)
        
        let qrCode = interactor.getQrCodeImage()
        view.setQrCode(qrCode)
    }
}


// MARK: - Private methods

extension DepositPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .horizontalSmall)
        return deviceLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setHidableNavigationBar(title: LocalizedStrings.navigationBarTitle)
    }
}
