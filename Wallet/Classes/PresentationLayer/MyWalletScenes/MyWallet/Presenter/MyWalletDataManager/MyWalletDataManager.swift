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
    func snapshotOfSelectedItem(_ snapshot: UIView)
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
        self.accounts = accounts
        collectionView.reloadData()
    }
    
    func reloadData() {
        collectionView.reloadData()
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
        let fiatAmount = accountDisplayer.fiatAmount(for: account)
        let holderName = accountDisplayer.holderName()
        let textColor = accountDisplayer.textColor(for: account)
        let backgroundImage: UIImage
        
        switch cellType {
        case .small:
            backgroundImage = accountDisplayer.smallImage(for: account)
        case .regular:
            backgroundImage = accountDisplayer.image(for: account)
        }
        
        
        cell.configureWith(cryptoAmount: cryptoAmount,
                           fiatAmount: fiatAmount,
                           holderName: holderName,
                           textColor: textColor,
                           backgroundImage: backgroundImage)
//        cell.setTestColor(indexPath.row)
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MyWalletDataManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let account = accounts[indexPath.row]
        delegate?.selectAccount(account)
        
        if let cell = collectionView.cellForItem(at: indexPath),
            let snapshot = cell.snapshotView(afterScreenUpdates: false) {
            snapshot.frame = collectionView.convert(cell.frame, to: collectionView.superview!)
            delegate?.snapshotOfSelectedItem(snapshot)
        }
        
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newValue = scrollView.contentOffset.y + scrollView.contentInset.top
        delegate?.didChangeOffset(newValue)
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
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let size = CGSize(width: 200, height: 100)
        return size
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
