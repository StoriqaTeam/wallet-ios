//
//  SettingsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsViewController: UITableViewController {

    var output: SettingsViewOutput!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView")
        let headerView = cell as! SettingsHeaderView
        headerView.configure(with: headerDataSource[section])
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 { return 52 }
        return 44
    
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
}


// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    
    func setupInitialState() {
        loadNib()
    }

}


// MARK: - Private methods

extension SettingsViewController {
    private func loadNib() {
        let headerNib = UINib(nibName: "SettingsHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
    }
}
