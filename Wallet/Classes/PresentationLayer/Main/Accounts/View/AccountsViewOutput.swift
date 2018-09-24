//
//  AccountsViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AccountsViewOutput: class {
    func accountsCollectionView(_ collectionView: UICollectionView)
    func transactionTableView(_ tableView: UITableView)
    func viewIsReady()
}
