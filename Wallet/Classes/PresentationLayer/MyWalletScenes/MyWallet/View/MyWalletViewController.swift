//
//  MyWalletViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.MyWallet

    var output: MyWalletViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var navigationBarTopConstraint: NSLayoutConstraint!
    @IBOutlet private var addCardNavigationButton: UIButton!
    
    // MARK: variables
    
    private let addNewButton = ResizableNavigationBarButton(title: LocalizedStrings.buttonTitle)
    private let accountCellIdentifier = "AccountViewCell"
    private var didLayoutSubviews = false
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setUpCollectionView()
        output.accountsCollectionView(collectionView)
        output.navigationBar(navigationBar)
        output.viewIsReady()
        
        // FIXME: подумать, как сделать лучше
        self.addCardNavigationButton.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    // MARK: Actions
    
    @IBAction private func addNew() {
        output.addNewTapped()
    }
}


// MARK: - MyWalletViewInput

extension MyWalletViewController: MyWalletViewInput {
    
    func setNavigationBarTopSpace(_ topSpace: CGFloat) {
        navigationBarTopConstraint.constant = topSpace
    }
    
    func setNavigationBarHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.navigationBar.alpha = hidden ? 0 : 1
            self.addCardNavigationButton.alpha = hidden ? 0 : 1
        }
    }
    
    func setupInitialState() {
        
    }

    func reloadWithAccounts() {
        
        //TODO: что показывать, когда нет счетов
        //TODO: что показывать, когда ошибка получения
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
}


// MARK: - Private methods

extension MyWalletViewController {
    
    private func configureNavBar() {
        
        // FIXME: hidden before release
        
//        addNewButton.addToNavigationBar(navigationBar)
//        addNewButton.addTarget(self, action: #selector(addNew), for: .touchUpInside)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showBarButton(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.addNewButton.alpha = show ? 1.0 : 0.0
        }
    }
    
    private func setUpCollectionView() {
        let topInset = navigationBar.frame.height
        collectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        collectionViewTopConstraint.constant = statusBarHeight
    }
    
}
