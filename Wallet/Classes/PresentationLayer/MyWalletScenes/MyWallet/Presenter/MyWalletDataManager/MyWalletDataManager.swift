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
    func rectOfSelectedItem(_ rect: CGRect?, in collectionView: UICollectionView)
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
        
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension MyWalletDataManager: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let account = accounts[indexPath.row]
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let frame = attributes?.frame
        delegate?.rectOfSelectedItem(frame, in: collectionView)
        delegate?.selectAccount(account)
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newValue = scrollView.contentOffset.y + scrollView.contentInset.top
        delegate?.didChangeOffset(newValue)
    }
    
}


// MARK: - Private methods

extension MyWalletDataManager {
    
    private func registerXib(identifier: String) {
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: kAccountCellIdentifier)
    }
    
}
