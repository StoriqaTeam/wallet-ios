//
//  RecipientAccountsViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RecipientAccountsViewOutput: class {
    func viewIsReady()
    func accountsCollectionView(_ collectionView: UICollectionView)
}
