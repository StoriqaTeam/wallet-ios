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
    func viewWillAppear()
    func accountsCollectionView(_ collectionView: UICollectionView)
    func configureCollections()
    
    func isValidAmount(_ amount: String) -> Bool
    func cryptoAmountChanged(_ amount: String)
    func fiatAmountChanged(_ amount: String)
    func cryptoAmountDidBeginEditing()
    func cryptoAmountDidEndEditing()
    func fiatAmountDidBeginEditing()
    func fiatAmountDidEndEditing()
    func receiverAddressDidChange(_ address: String)
    func newFeeSelected(_ index: Int)
    
    func scanButtonPressed()
    func sendButtonPressed()
}
