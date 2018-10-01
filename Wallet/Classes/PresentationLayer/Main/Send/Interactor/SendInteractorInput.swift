//
//  SendInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendInteractorInput: class {
    
    func getAccountsCount() -> Int
    func scrollCollection()
    func createAccountsDataManager(with collectionView: UICollectionView)
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate)
    
    func isValidAmount(_ amount: String) -> Bool
    func setAmount(_ amount: String)
    func getAmountWithCurrency() -> String
    func getAmountWithoutCurrency() -> String
    func setReceiverCurrency(_ currency: Currency)
    func setCurrentAccountWith(index: Int)
    func isFormValid() -> Bool
    
    func getTransactionBuilder() -> SendTransactionBuilderProtocol
}
