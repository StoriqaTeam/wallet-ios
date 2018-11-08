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
    
    @IBOutlet private var sessionsCountLabel: UILabel!

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
}


// MARK: - Table View methods

extension SettingsViewController {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // FIXME: hidden before release
            switch indexPath.row {
            case 0:
                output.myProfileSelected()
            case 1:
//                output.changePhoneSelected()
//            case 2:
            output.changePasswordSelected()
            default:
                break
            }
        }
        
        // FIXME: hidden before release
//        if indexPath.section == 2 {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                output.sessionSelected()
            default:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func setupInitialState() {
        loadNib()
        view.backgroundColor = .white
        tableView.alwaysBounceVertical = false
    }
    
    func setSessions(count: Int) {
        sessionsCountLabel.text = "\(count)"
    }
}


// MARK: - Private methods

extension SettingsViewController {
    private func loadNib() {
        let headerNib = UINib(nibName: "SettingsHeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
    }
}
