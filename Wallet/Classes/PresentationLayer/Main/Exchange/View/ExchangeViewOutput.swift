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
    func accountsCollectionView(_ collectionView: UICollectionView)
    func accountsActionSheet(_ tableView: UITableView)
    func configureCollections()
    
    func isValidAmount(_ amount: String) -> Bool
    func amountChanged(_ amount: String)
    func amountDidBeginEditing()
    func amountDidEndEditing()
    
    func newFeeSelected(_ index: Int)
    
    func recepientAccountPressed()
    func exchangeButtonPressed()
}
