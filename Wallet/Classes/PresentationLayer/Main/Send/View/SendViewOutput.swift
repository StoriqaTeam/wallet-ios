//
//  SendViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendViewOutput: class {
    func viewIsReady()
    func accountsCollectionView(_ collectionView: UICollectionView)
    func isValidAmount(_ amount: String) -> Bool
    func amountChanged(_ amount: String)
    func receiverCurrencyChanged(_ index: Int)
    func getAmountWithCurrency() -> String
    func getAmountWithoutCurrency() -> String
    func configureCollections()
    func nextButtonPressed()
}
