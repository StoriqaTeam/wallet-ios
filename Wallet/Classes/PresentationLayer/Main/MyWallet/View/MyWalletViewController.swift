//
//  MyWalletViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {

    var output: MyWalletViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: variables
    
    private let addNewButton = ResizableNavigationBarButton(title: "add_new".localized() + " \u{FF0B}")
    private let accountCellIdentifier = "AccountViewCell"
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        registerReusableCells()
        setDelegates()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBarButton(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBarButton(false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        addNewButton.moveAndResizeImage(for: height)
    }
    
    // MARK: Actions
    
    @IBAction private func addNew() {
        //TODO: remove this
        
        showAlert(message: "Add new button tapped")
    }
}


// MARK: - MyWalletViewInput

extension MyWalletViewController: MyWalletViewInput {
    
    func setupInitialState(flowLayout: UICollectionViewFlowLayout) {
        collectionView.collectionViewLayout = flowLayout
    }

    func reloadWithAccounts() {
        
        //TODO: что показывать, когда нет счетов
        //TODO: что показывать, когда ошибка получения
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
}


// MARK: - Private methods

extension MyWalletViewController {
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.topItem?.title = "my_wallet".localized()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        addNewButton.addToNavigationBar(navigationBar)
        addNewButton.addTarget(self, action: #selector(addNew), for: .touchUpInside)
    }
    
    private func registerReusableCells() {
        //custom collectionViewCell
        collectionView.register(UINib(nibName: accountCellIdentifier, bundle: nil), forCellWithReuseIdentifier: accountCellIdentifier)
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


// MARK: - UICollectionViewDelegate

extension MyWalletViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.selectItemAt(index: indexPath.row)
    }
}


// MARK: - UICollectionViewDataSource

extension MyWalletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return output.accountsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let account = output.accountModel(for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: accountCellIdentifier, for: indexPath) as! AccountViewCell
        cell.configureWith(account: account)
        cell.setBackgroundImage(account.imageForType)
        return cell
    }
    
}
