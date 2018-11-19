//
//  RecepientAccountsViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol RecepientAccountsViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func accountsCollectionView(_ collectionView: UICollectionView)
}
