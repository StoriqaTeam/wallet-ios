//
//  MyWalletPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AudioToolbox.AudioServices


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
    private var hideNotificationAnimator: UIViewPropertyAnimator?
    private var notificationView: UIView?
    private var isPanGestureActive = false
    private let animator: MyWalletToAccountsAnimator
    
    init(accountDisplayer: AccountDisplayerProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         animator: MyWalletToAccountsAnimator) {
        
        self.accountDisplayer = accountDisplayer
        self.denominationUnitsConverter = denominationUnitsConverter
        self.currencyFormatter = currencyFormatter
        self.animator = animator
    }
}


// MARK: - MyWalletViewOutput

extension MyWalletPresenter: MyWalletViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.startObservers()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        view.setNavigationBarTopSpace(statusBarHeight)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        let xOrigin = (Constants.Sizes.screenWidth - collectionFlowLayout.itemSize.width) / 2
        view.setNavigationBarHorizontalSpace(xOrigin)
        
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = MyWalletDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        addPullToRefresh(collectionView: collectionView)
        accountsManager.setCollectionView(collectionView)
        dataManager = accountsManager
        dataManager.delegate = self
    }
    
    
    func navigationBar(_ navigationBar: UINavigationBar) {
        view.viewController.setWhiteNavigationBarButtons()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBarButton")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBarButton")
        
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.title = "my_wallet".localized()
        
        var titleTextAttributes = navigationBar.titleTextAttributes ?? [NSAttributedString.Key: Any]()
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.largeTitleTextAttributes = titleTextAttributes
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
            let maxEth = denominationUnitsConverter.amountToMaxUnits(eth, currency: .eth)
            let ethStr = currencyFormatter.getStringFrom(amount: maxEth, currency: .eth)
            
            if !notificationStr.isEmpty {
                notificationStr += ", "
            }
            
            notificationStr += ethStr
        }
        
        if !btc.isZero {
            let maxBtc = denominationUnitsConverter.amountToMaxUnits(btc, currency: .btc)
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
    func rectOfSelectedItem(_ rect: CGRect?, in collectionView: UICollectionView) {
        guard let frame = rect else { return }
        let accountFrame = collectionView.convert(frame, to: viewController.view)
        animator.setInitialFrame(accountFrame)

    }
    
    
    func selectAccount(_ account: Account) {
        let accountWatcher = interactor.getAccountWatcher()
        accountWatcher.setAccount(account)
        router.showAccountsWith(accountWatcher: accountWatcher,
                                from: view.viewController,
                                tabBar: mainTabBar,
                                animator: animator)
    }
    
    func didChangeOffset(_ newValue: CGFloat) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        guard newValue > 0 else {
            let newOffset = floor(newValue / 5)
            view.setNavigationBarTopSpace(statusBarHeight - newOffset)
            return
        }
        
        guard newValue < 50 else {
            return
        }
        
        view.setNavigationBarTopSpace(statusBarHeight - newValue)
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
        
        let bounceLayout = BouncyLayout(style: .prominent)
        bounceLayout.setConfigureFlow(flow: flowLayout)
        
        return bounceLayout
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
        if notificationView != nil {
            self.notificationView?.removeFromSuperview()
            self.notificationView = nil
            self.hideNotificationAnimator?.stopAnimation(true)
            self.hideNotificationAnimator = nil
            isPanGestureActive = false
        }
        
        addNotificationView(message: message)
        
        guard let notificationView = notificationView else {
            return
        }
        
        let shownOrigin = CGPoint.zero
        let hiddenOrigin = notificationView.frame.origin
        let animator = UIViewPropertyAnimator(duration: 0.35, dampingRatio: 0.5) {
            notificationView.frame.origin = shownOrigin
        }
        
        animator.startAnimation()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        hideNotificationAnimator = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            notificationView.frame.origin = hiddenOrigin
        })
        hideNotificationAnimator?.addCompletion({ _ in
            self.notificationView?.removeFromSuperview()
            self.notificationView = nil
            self.hideNotificationAnimator = nil
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hideNotification()
        }
    }
    
    @objc private func hideNotification() {
        guard !isPanGestureActive else { return }
        hideNotificationAnimator?.startAnimation()
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let notificationView = notificationView else {
            return
        }
        
        let window = AppDelegate.currentWindow
        let translation = recognizer.translation(in: window)
        
        switch recognizer.state {
        case .began:
            isPanGestureActive = true
            
        case .ended:
            isPanGestureActive = false
            
            if translation.y < -10 {
                hideNotification()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    self?.hideNotification()
                }
            }
        default:
            let progress = max(0, min(1, -translation.y / notificationView.frame.height))
            hideNotificationAnimator?.fractionComplete = progress
        }
    }
    
    private func addNotificationView(message: String) {
        let window = AppDelegate.currentWindow
        let viewWidth = Constants.Sizes.screenWidth
        let hiddenOrigin = CGPoint(x: 0, y: -200)
        let txNotificationView = NotificationView(frame: CGRect(origin: hiddenOrigin, size: CGSize(width: viewWidth, height: 200)))
        txNotificationView.setMessage(message)
        txNotificationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([txNotificationView.widthAnchor.constraint(equalToConstant: viewWidth)])
        txNotificationView.layoutIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideNotification))
        txNotificationView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        txNotificationView.addGestureRecognizer(pan)
        
        window.addSubview(txNotificationView)
        notificationView = txNotificationView
    }
}
