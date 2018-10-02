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
    private var kAccountCellIdentifier = ""
    private var indexOfCellBeforeDragging = 0
    private var accounts: [Account]
    
    init(accounts: [Account]) {
        self.accounts = accounts
    }
    
    func setCollectionView(_ view: UICollectionView, cellIdentifier: String = "AccountViewCell") {
        kAccountCellIdentifier = cellIdentifier
        
        accountsCollectionView = view
        accountsCollectionView.dataSource = self
        accountsCollectionView.delegate = self
        accountsCollectionView.isPagingEnabled = false
        accountsCollectionView.clipsToBounds = false
        registerXib()
    }
    
    func updateAccounts(_ accounts: [Account]) {
        self.accounts = accounts
        accountsCollectionView.reloadData()
    }
    
    func scrollTo(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        accountsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate.currentPageDidChange(indexPath.row)
    }
    
}


// MARK: - UICollectionViewDataSource

extension AccountsDataManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let account = accounts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAccountCellIdentifier, for: indexPath)
        
        if let cell = cell as? AccountCellProtocol {
            cell.configWithAccountModel(account)
            cell.dropShadow()
        }
        
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
        
        let layout = accountsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let dataSourceCount = accounts.count
        let swipeVelocityThreshold: CGFloat = 0.4
        let enoughVelocityToNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let enoughVelocityToPreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let didUseSwipeToSkipCell = enoughVelocityToNextCell || enoughVelocityToPreviousCell
        
        if didUseSwipeToSkipCell {
            let itemsToScroll = max(1, Int(round(abs(velocity.x / 2)))) * (enoughVelocityToNextCell ? 1 : -1)
            let snapToIndex = max(0, min(dataSourceCount - 1, indexOfCellBeforeDragging + itemsToScroll))
            let toValue = (layout.itemSize.width + layout.minimumLineSpacing) * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: velocity.x,
                           options: [.allowUserInteraction, .curveEaseOut],
                           animations: {
                            scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                            scrollView.layoutIfNeeded()
            }, completion: nil)
            
            delegate.currentPageDidChange(snapToIndex)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexOfMajorCell = self.indexOfMajorCell()
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            accountsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            delegate.currentPageDidChange(indexPath.row)
        }
    }
}


// MARK: - Private methods

extension AccountsDataManager {
    private func indexOfMajorCell() -> Int {
        let layout = accountsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width
        let proportionalOffset = accountsCollectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = accounts.count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    private func registerXib() {
        let nib = UINib(nibName: kAccountCellIdentifier, bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: kAccountCellIdentifier)
    }
}
