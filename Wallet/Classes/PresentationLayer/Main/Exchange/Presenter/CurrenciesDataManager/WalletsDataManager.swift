//
//  CurrenciesDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

enum WalletType: String {
    case fiat
    case btc
    case eth
    case stq
    
    var description: String {
        switch self {
        case .fiat:
            return "To credit/debit card"
        case .btc:
            return "Bitcoin wallet"
        case .eth:
            return "Ethereum wallet"
        case .stq:
            return "STQ wallet"
        }
    }
}

protocol WalletsDataManagerDelegate: class {
    func chooseWallet()
}


class WalletsDataManager: NSObject {
    
    weak var delegate: WalletsDataManagerDelegate!
    
    private var walletsTableView: UITableView!
    private let kCurrenciesCellIdentifier = "CurrencyCell"
    private let wallets: [WalletType] = [.fiat, .btc, .eth, .stq]
    
    func setTableView(_ view: UITableView) {
        walletsTableView = view
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        registerXib()
    }
    
}


// MARK: - UITableViewDataSource

extension WalletsDataManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wallet = wallets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kCurrenciesCellIdentifier, for: indexPath) as! WalletTableViewCell
        cell.configure(wallet: wallet)
        return cell
    }
    
    
}


// MARK: - UITableViewDelegate

extension WalletsDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.chooseWallet()
    }
}


// MARK: - Private methods

extension WalletsDataManager {
    private func registerXib() {
        let nib = UINib(nibName: kCurrenciesCellIdentifier, bundle: nil)
        walletsTableView.register(nib, forCellReuseIdentifier: kCurrenciesCellIdentifier)
    }
}
