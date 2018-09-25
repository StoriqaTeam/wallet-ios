//
//  ReceiverViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ReceiverViewOutput: class {
    func viewIsReady()
    func contactsTableView(_ tableView: UITableView)
    func inputDidChange(_ input: String)
    func editButtonPressed()
    func scanButtonPressed()
}
