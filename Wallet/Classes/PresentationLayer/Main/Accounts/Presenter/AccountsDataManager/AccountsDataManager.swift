//
//  AccountsDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol AccountsDataManagerDelegate: class {
    func currentPageDidChange(_ newIndex: Int)
}


class AccountsDataManager: NSObject {
    
    weak var delegate: AccountsDataManagerDelegate!
    
    private var accountsCollectionView: UICollectionView!
    private let kAccountCellIdentifier = "AccountViewCell"
    private var indexOfCellBeforeDragging = 0
    private var accounts: [Account]
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
    
    func setCollectionView(_ view: UICollectionView) {
        accountsCollectionView = view
        accountsCollectionView.dataSource = self
        accountsCollectionView.delegate = self
        registerXib()
    }
    
    func updateAccounts(_ accounts: [Account]) {
        self.accounts = accounts
        accountsCollectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDataSource

extension AccountsDataManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let account = accounts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAccountCellIdentifier, for: indexPath) as! AccountViewCell
        cell.configWithAccountModel(account)
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension AccountsDataManager: UICollectionViewDelegate {
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        accountsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate.currentPageDidChange(indexPath.row)
    }
}


// MARK: - Private methods

extension AccountsDataManager {
    private func indexOfMajorCell() -> Int {
        
        let layout = accountsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWidth = layout.itemSize.width
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = layout.collectionView?.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems! - 1, index))
        return safeIndex
    }
    
    private func registerXib() {
        let nib = UINib(nibName: kAccountCellIdentifier, bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: kAccountCellIdentifier)
    }
}
