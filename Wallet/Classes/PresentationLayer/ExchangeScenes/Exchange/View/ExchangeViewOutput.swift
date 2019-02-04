//
//  ExchangeViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func fromAccountsCollectionView(_ collectionView: UICollectionView)
    func toAccountsCollectionView(_ collectionView: UICollectionView)
    func configureCollections()
    
    func isValidAmount(_ amount: String) -> Bool
    func fromAmountChanged(_ amount: String)
    func toAmountChanged(_ amount: String)
    func fromAmountDidBeginEditing()
    func fromAmountDidEndEditing()
    func toAmountDidBeginEditing()
    func toAmountDidEndEditing()
    
    func exchangeButtonPressed()
}
