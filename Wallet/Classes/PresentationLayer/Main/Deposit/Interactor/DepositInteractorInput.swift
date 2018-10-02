//
//  DepositInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol DepositInteractorInput: class {
    func createAccountsDataManager(with collectionView: UICollectionView)
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate)
    func scrollCollection()
    func getAccountsCount() -> Int
    func setCurrentAccountWith(index: Int)
    func getAddress() -> String
    func getQrCodeImage() -> UIImage
}
