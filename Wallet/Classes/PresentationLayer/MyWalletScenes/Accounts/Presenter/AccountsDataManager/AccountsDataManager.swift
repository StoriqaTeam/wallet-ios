//
//  AccountsDataManager.swift
//  Wallet
//
//  Created by Storiqa on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol AccountsDataManagerDelegate: class {
    func currentPageDidChange(_ newIndex: Int, manager: AccountsDataManager)
}

class AccountsDataManager: NSObject {
    enum CellType {
        case small
        case regular
        case thin
    }
    
    weak var delegate: AccountsDataManagerDelegate?
    
    private var accountsCollectionView: UICollectionView!
    private var cellType: CellType = .regular
    private let kAccountCellIdentifier = "AccountCell"
    private var indexOfCellBeforeDragging = 0
    private var accounts: [Account]
    private let accountDisplayer: AccountDisplayerProtocol
    
    init(accounts: [Account], accountDisplayer: AccountDisplayerProtocol) {
        self.accounts = accounts
        self.accountDisplayer = accountDisplayer
    }
    
    func setCollectionView(_ view: UICollectionView, cellType: CellType = .regular) {
        self.cellType = cellType
        accountsCollectionView = view
        accountsCollectionView.dataSource = self
        accountsCollectionView.delegate = self
        accountsCollectionView.isPagingEnabled = false
        accountsCollectionView.clipsToBounds = false
        accountsCollectionView.showsHorizontalScrollIndicator = false
        accountsCollectionView.showsVerticalScrollIndicator = true
        
        let cellIdentifier: String
        switch cellType {
        case .small:
            cellIdentifier = "SmallAccountCell"
        case .regular:
            cellIdentifier = "AccountViewCell"
        case .thin:
            cellIdentifier = "ThinAccountCell"
        }
        registerXib(identifier: cellIdentifier)
    }
    
    func updateAccounts(_ accounts: [Account]) {
        self.accounts = accounts
        accountsCollectionView.reloadData()
    }
    
    func updateAccountsAnimated(_ accounts: [Account], completion: @escaping () -> Void) {
        self.accounts = accounts
        
        accountsCollectionView.performBatchUpdates({
            let indexSet = IndexSet(integer: 0)
            self.accountsCollectionView.reloadSections(indexSet)
        }, completion: { (finished) in
            if finished {
                completion()
            }
        })
    }
    
    
    func reloadData() {
        accountsCollectionView.reloadData()
    }
    
    func scrollTo(index: Int) {
        guard index < accounts.count else { return }
        
        let prevIndex = self.indexOfMajorCell()
        let indexPath = IndexPath(row: index, section: 0)
        accountsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        if prevIndex != index {
            delegate?.currentPageDidChange(index, manager: self)
        }
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
        
        let cryptoAmount = accountDisplayer.cryptoAmount(for: account)
        let cryptoAmountWithoutCurrency = accountDisplayer.cryptoAmountWithoutCurrency(for: account)
        let fiatAmount = accountDisplayer.fiatAmount(for: account)
        let accountName = accountDisplayer.accountName(for: account)
        let currency = accountDisplayer.currency(for: account)
        let textColor = accountDisplayer.textColor(for: account)
        let backgroundImage: UIImage
        let amountFont: UIFont
        
        switch cellType {
        case .thin:
            backgroundImage = accountDisplayer.thinImage(for: account)
            amountFont = Theme.Font.AccountCards.smallCardAmount!
        case .small:
            backgroundImage = accountDisplayer.smallImage(for: account)
            amountFont = Theme.Font.AccountCards.smallCardAmount!
        case .regular:
            backgroundImage = accountDisplayer.image(for: account)
            amountFont = Theme.Font.AccountCards.bigCardAmount!
        }
        
        cell.configureWith(cryptoAmount: cryptoAmount,
                           cryptoAmountWithoutCurrency: cryptoAmountWithoutCurrency,
                           fiatAmount: fiatAmount,
                           accountName: accountName,
                           currency: currency,
                           textColor: textColor,
                           backgroundImage: backgroundImage,
                           bigAmountFont: amountFont)
        cell.dropShadow()
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension AccountsDataManager: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
            
            delegate?.currentPageDidChange(snapToIndex, manager: self)
            
        } else {
            let indexOfMajorCell = self.indexOfMajorCell()
            
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            accountsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            if indexOfCellBeforeDragging != indexOfMajorCell {
                delegate?.currentPageDidChange(indexOfMajorCell, manager: self)
            }
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
    
    private func registerXib(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        accountsCollectionView.register(nib, forCellWithReuseIdentifier: kAccountCellIdentifier)
    }
}
