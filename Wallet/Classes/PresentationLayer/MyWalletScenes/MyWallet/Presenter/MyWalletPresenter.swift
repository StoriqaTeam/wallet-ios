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
    
    private let accountDisplayer: AccountDisplayerProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private var dataManager: MyWalletDataManager!
    private var pullToRefresh: UIRefreshControl!
    private var notificationTopConstraint: NSLayoutConstraint?
    private var notificationView: UIView?
    
    init(accountDisplayer: AccountDisplayerProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol,
         currencyFormatter: CurrencyFormatterProtocol) {
        self.accountDisplayer = accountDisplayer
        self.denominationUnitsConverter = denominationUnitsConverter
        self.currencyFormatter = currencyFormatter
    }
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
        interactor.startObservers()
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = MyWalletDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        addPullToRefresh(collectionView: collectionView)
        accountsManager.setCollectionView(collectionView)
        dataManager = accountsManager
        dataManager.delegate = self
    }
    
    func addNewTapped() {
        // TODO: addNewTapped
        // TODO: Fix TODO description
    }
    
}


// MARK: - MyWalletInteractorOutput

extension MyWalletPresenter: MyWalletInteractorOutput {
    func updateAccounts(accounts: [Account]) {
        dataManager?.updateAccounts(accounts: accounts)
    }
    
    func userDidUpdate() {
        dataManager?.reloadData()
    }
    
    func receivedNewTxs(stq: Decimal, eth: Decimal, btc: Decimal) {
        var notificationStr = ""
        
        if !stq.isZero {
            let maxStq = denominationUnitsConverter.amountToMaxUnits(stq, currency: .stq)
            let stqStr = currencyFormatter.getStringFrom(amount: maxStq, currency: .stq)
            
            notificationStr += stqStr
        }
        
        if !eth.isZero {
            let maxEth = denominationUnitsConverter.amountToMaxUnits(stq, currency: .eth)
            let ethStr = currencyFormatter.getStringFrom(amount: maxEth, currency: .eth)
            
            if !notificationStr.isEmpty {
                notificationStr += ", "
            }
            
            notificationStr += ethStr
        }
        
        if !btc.isZero {
            let maxBtc = denominationUnitsConverter.amountToMaxUnits(stq, currency: .btc)
            let btcStr = currencyFormatter.getStringFrom(amount: maxBtc, currency: .btc)
            
            if !notificationStr.isEmpty {
                notificationStr += ", "
            }
            
            notificationStr += btcStr
        }
        
        if !notificationStr.isEmpty {
            notificationStr = "You received " + notificationStr
            showReceivedNotification(message: notificationStr)
        }
        
    }
    
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
        let deviceLayout = Device.model.flowLayout(type: .vertical)
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
        guard let navBar = view.viewController.navigationController?.navigationBar else { return }

        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "my_wallet".localized()
        
        view.viewController.setWhiteNavigationBarButtons()
        var titleTextAttributes = navBar.titleTextAttributes ?? [NSAttributedString.Key: Any]()
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        navBar.titleTextAttributes = titleTextAttributes
        navBar.largeTitleTextAttributes = titleTextAttributes
    }
    
    private func addPullToRefresh(collectionView: UICollectionView) {
        pullToRefresh = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
        pullToRefresh.tintColor = .white
        pullToRefresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(pullToRefresh)
    }
    
    @objc private func loadData() {
        interactor.refreshAccounts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.pullToRefresh.endRefreshing()
        }
    }
    
    private func showReceivedNotification(message: String) {
        let window = AppDelegate.currentWindow
        
        let screenWidth = Constants.Sizes.screenWidth
        let font = Theme.Font.smallMediumWeightText
        let strHeight = message.height(withConstrainedWidth: screenWidth - 40 - 32, font: font)
        let viewHeight = strHeight + 40
        
        let txNotificationView = UIView(frame: CGRect(x: 20, y: 20, width: screenWidth - 40, height: viewHeight))
        txNotificationView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        txNotificationView.roundCorners(radius: 10)
        txNotificationView.isUserInteractionEnabled = true
        
        let label = UILabel(frame: CGRect(x: 16, y: 20, width: txNotificationView.frame.width - 32, height: strHeight))
        label.text = message
        label.font = font
        label.textColor = .white
        label.numberOfLines = 0
        txNotificationView.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideNotification))
        txNotificationView.addGestureRecognizer(tap)
        
        window.addSubview(txNotificationView)
        
        txNotificationView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = txNotificationView.topAnchor.constraint(equalTo: window.topAnchor, constant: -(viewHeight + 20))
        let centerXConstraint = txNotificationView.centerXAnchor.constraint(equalTo: window.centerXAnchor, constant: 0)
        let widthConstraint = txNotificationView.widthAnchor.constraint(equalToConstant: screenWidth - 40)
        let heightConstraint = txNotificationView.heightAnchor.constraint(equalToConstant: viewHeight)
        NSLayoutConstraint.activate([topConstraint, centerXConstraint, widthConstraint, heightConstraint])
        
        self.notificationTopConstraint = topConstraint
        self.notificationView = txNotificationView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            
            self?.notificationTopConstraint?.constant = 20
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                window.layoutIfNeeded()
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.hideNotification()
                }
            })
        }
    }
    
    @objc private func hideNotification() {
        guard let notificationView = notificationView else {
            return
        }
        
        notificationTopConstraint?.constant = -(notificationView.frame.height + 20)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            AppDelegate.currentWindow.layoutIfNeeded()
        }, completion: { _ in
            notificationView.removeFromSuperview()
            self.notificationView = nil
        })
    }
}
