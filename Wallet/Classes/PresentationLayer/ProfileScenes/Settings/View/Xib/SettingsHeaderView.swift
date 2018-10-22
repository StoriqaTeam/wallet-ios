//
//  SettingsHeaderView.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private var headerTitle: UILabel!
    @IBOutlet private var headerImageView: UIImageView!
    
    func configure(with header: SettingsHeader) {
        headerTitle.text = header.headerTitle
        headerImageView.image = header.headerImage
    }
    
}


struct SettingsHeader {
    let headerTitle: String
    let headerImage: UIImage?
}

let headerDataSource = [
    SettingsHeader(headerTitle: "ACCOUNT", headerImage: UIImage(named: "accountProfileIcon")),
    SettingsHeader(headerTitle: "NOTIFICATIONS", headerImage: UIImage(named: "notifProfileIcon")),
    SettingsHeader(headerTitle: "MORE", headerImage: UIImage(named: "moreProfileIcon"))
]
