//
//  MyWalletDataManager.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol MyWalletDataManagerDelegate: class {
    func selectAccount(_ account: Account)
    func didChangeOffset(_ newValue: CGFloat)
    func snapshotsForTransition(snapshots: [UIView], selectedIndex: Int)
}

class MyWalletDataManager: NSObject {
    enum CellType {
        case small
        case regular
    }
    
    weak var delegate: MyWalletDataManagerDelegate?
    
    private var collectionView: UICollectionView!
    private var cellType: CellType = .regular
    private let kAccountCellIdentifier = "AccountViewCell"
    private var accounts: [Account]
    private let accountDisplayer: AccountDisplayerProtocol
    private var shouldUpdateCellsPositions = false
    
    var springFlowLayout: SpringFlowLayout? {
        return collectionView.collectionViewLayout as? SpringFlowLayout
    }
    
    init(accounts: [Account], accountDisplayer: AccountDisplayerProtocol) {
        self.accounts = accounts
        self.accountDisplayer = accountDisplayer
    }
    
    func setCollectionView(_ view: UICollectionView, cellType: CellType = .regular) {
        self.cellType = cellType
        collectionView = view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cellIdentifier: String
        switch cellType {
        case .small:
            cellIdentifier = "SmallAccountCell"
        case .regular:
            cellIdentifier = "AccountViewCell"
        }
        registerXib(identifier: cellIdentifier)
    }
    
    func updateAccounts(accounts: [Account]) {
        let accCount = self.accounts.count
        self.accounts = accounts
        
        collectionView.reloadData()
        
        if accCount != accounts.count {
            springFlowLayout?.removeFooterBehavior()
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
        springFlowLayout?.removeFooterBehavior()
    }
    
    func restoreVisibility() {
        collectionView.alpha = 1
        springFlowLayout?.setSnapshotsHidden(false)
    }
    
}


// MARK: - UICollectionViewDataSource

extension MyWalletDataManager: UICollectionViewDataSource {
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
        
        switch cellType {
        case .small:
            backgroundImage = accountDisplayer.smallImage(for: account)
        case .regular:
            backgroundImage = accountDisplayer.image(for: account)
        }
        
        
        cell.configureWith(cryptoAmount: cryptoAmount,
                           cryptoAmountWithoutCurrency: cryptoAmountWithoutCurrency,
                           fiatAmount: fiatAmount,
                           accountName: accountName,
                           currency: currency,
                           textColor: textColor,
                           backgroundImage: backgroundImage)
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MyWalletDataManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let visibleCells = collectionView.visibleCells.sorted(by: {
            guard let firstRow = collectionView.indexPath(for: $0)?.row,
                let secondRow = collectionView.indexPath(for: $1)?.row else {
                    return true
            }
            
            return firstRow < secondRow
        })
        
        let account = accounts[indexPath.row]
        delegate?.selectAccount(account)
        
        guard var selectedIndex = visibleCells.firstIndex(where: { collectionView.indexPath(for: $0) == indexPath }) else {
            return true
        }
        
        var snapshots = visibleCells.compactMap { (cell) -> UIView? in
            let snapshot = cell.snapshotView(afterScreenUpdates: false)
            snapshot?.frame = collectionView.convert(cell.frame, to: collectionView.superview!)
            return snapshot
        }
        
        if let footer = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionFooter).first,
            let snapshot = footer.snapshotView(afterScreenUpdates: false) {
            snapshot.frame = collectionView.convert(footer.frame, to: collectionView.superview!)
            snapshots.append(snapshot)
        }
        
        if let layout = springFlowLayout {
            if let topCell = layout.getLastTopCellSnapshot() {
                snapshots.insert(topCell, at: 0)
                selectedIndex += 1
            }
            layout.setSnapshotsHidden(true)
        }
        
        delegate?.snapshotsForTransition(snapshots: snapshots, selectedIndex: selectedIndex)
        collectionView.alpha = 0
        
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newValue = scrollView.contentOffset.y + scrollView.contentInset.top
        delegate?.didChangeOffset(newValue)
        springFlowLayout?.collectionDidChangeOffset()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let minVisibleRow = collectionView.indexPathsForVisibleItems.map({ return $0.row }).min() ?? 0
        
        if indexPath.row == minVisibleRow - 1 {
            collectionView.sendSubviewToBack(cell)
        }
        
        if shouldUpdateCellsPositions {
            shouldUpdateCellsPositions = false
            
            let visiblePaths = collectionView.indexPathsForVisibleItems.sorted(by: { $0.row > $1.row })
            let visibleCells = visiblePaths.compactMap { collectionView.cellForItem(at: $0) }
            
            var previousCell: UIView?
            for cell in visibleCells {
                guard let prevCell = previousCell else {
                    previousCell = cell
                    continue
                }
                
                cell.removeFromSuperview()
                collectionView.insertSubview(cell, belowSubview: prevCell)
                previousCell = cell
            }
        }
        
        if indexPath.row < minVisibleRow {
            shouldUpdateCellsPositions = true
        }
    }
}

extension MyWalletDataManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "footerView",
                                                                             for: indexPath)
            return footerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}


// MARK: - Private methods

extension MyWalletDataManager {
    
    private func registerXib(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: kAccountCellIdentifier)
        collectionView.register(MyWalletFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footerView")
    }
    
}
