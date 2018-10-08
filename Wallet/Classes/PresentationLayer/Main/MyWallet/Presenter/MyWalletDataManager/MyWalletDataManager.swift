//
//  MyWalletDataManager.swift
//  Wallet
//
//  Created by Tata Gri on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol MyWalletDataManagerDelegate: class {
    func selectAccount(_ account: Account)
}

class MyWalletDataManager: NSObject {
    enum CellType {
        case small
        case regular
    }
    
    weak var delegate: MyWalletDataManagerDelegate?
    
    private var collectionView: UICollectionView!
    private let kAccountCellIdentifier = "AccountViewCell"
    private var accounts: [Account]
    private let accountDisplayer: AccountDisplayerProtocol
    
    init(accounts: [Account], accountDisplayer: AccountDisplayerProtocol) {
        self.accounts = accounts
        self.accountDisplayer = accountDisplayer
    }
    
    func setCollectionView(_ view: UICollectionView) {
        collectionView = view
        collectionView.dataSource = self
        collectionView.delegate = self
        registerXib()
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
        let holderName = accountDisplayer.holderName(for: account)
        let textColor = accountDisplayer.textColor(for: account)
        let backgroundImage = accountDisplayer.image(for: account)
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let account = accounts[indexPath.row]
        delegate?.selectAccount(account)
    }
    
}


// MARK: - Private methods

extension MyWalletDataManager {
    
    private func registerXib() {
        collectionView.register(UINib(nibName: kAccountCellIdentifier, bundle: nil), forCellWithReuseIdentifier: kAccountCellIdentifier)
    }
    
}
