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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        output.willMoveToParentVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView")
        let headerView = cell as! SettingsHeaderView
        headerView.configure(with: headerDataSource[section])
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        view.backgroundColor = .white
        tableView.alwaysBounceVertical = false
    }

}


// MARK: - Private methods

extension SettingsViewController {
    private func loadNib() {
        let headerNib = UINib(nibName: "SettingsHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
    }
}
