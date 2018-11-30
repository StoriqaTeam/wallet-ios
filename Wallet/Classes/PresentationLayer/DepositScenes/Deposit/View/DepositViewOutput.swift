//
//  DepositViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol DepositViewOutput: class {
    func viewIsReady()
    func viewWillAppear()
    func viewWillDisapear()
    func accountsCollectionView(_ collectionView: UICollectionView)
    func configureCollections()
    func copyButtonPressed()
    func shareButtonPressed()
}
