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
    
    // MARK: variables
    
    private let addNewButton = ResizableNavigationBarButton(title: LocalizedStrings.buttonTitle)
    private let accountCellIdentifier = "AccountViewCell"
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        output.accountsCollectionView(collectionView)
        output.viewIsReady()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBarButton(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBarButton(false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.gradientView(colors: Theme.Gradient.headerGradient,
                          frame: view.bounds,
                          startPoint: CGPoint(x: 0.0, y: 0.0),
                          endPoint: CGPoint(x: 1.0, y: 1.0),
                          insertFirst: true)
        guard let height = navigationController?.navigationBar.frame.height else { return }
        addNewButton.moveAndResizeImage(for: height)
    }
    
    // MARK: Actions
    
    @IBAction private func addNew() {
        output.addNewTapped()
    }
}


// MARK: - MyWalletViewInput

extension MyWalletViewController: MyWalletViewInput {
    
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
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationController?.navigationBar.barStyle = .blackTranslucent
        addNewButton.addToNavigationBar(navigationBar)
        addNewButton.addTarget(self, action: #selector(addNew), for: .touchUpInside)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showBarButton(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.addNewButton.alpha = show ? 1.0 : 0.0
        }
    }
    
}
