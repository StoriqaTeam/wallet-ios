//
//  SettingsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

private enum SettingsCell: Int {
    case editProfile = 0
    case changePassword
    case changePhone
    case appInfo
    
    static var count = 4
}

class SettingsViewController: UIViewController {

    var output: SettingsViewOutput!
    
    @IBOutlet private var settingsTableView: UITableView!
    @IBOutlet private var signOutButton: LightButton!
    
    private var changePhoneTitle: String = ""
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        output.signOutButtonTapped()
    }
    
}


// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info: String = {
            switch indexPath.row {
            case SettingsCell.editProfile.rawValue: return "Edit profile"
            case SettingsCell.changePassword.rawValue: return "Change password"
            case SettingsCell.changePhone.rawValue: return changePhoneTitle
            case SettingsCell.appInfo.rawValue: return "App info"
            default: return ""
            }
        }()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        guard let settingsCell = cell as? SettingsTableViewCell else { fatalError("Fail to cast cell") }
        settingsCell.configure(info: info)
        return settingsCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsCell.count
    }
}


// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case SettingsCell.editProfile.rawValue: output.editProfileSelected()
        case SettingsCell.changePassword.rawValue: output.changePasswordSelected()
        case SettingsCell.changePhone.rawValue: output.changePhoneNumber()
        case SettingsCell.appInfo.rawValue: output.appInfoSelected()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func setupInitialState() {
        setDelegates()
        registerCell()
        configureTableView()
        configureInterface()
    }
    
    func setChangePhoneTitle(_ title: String) {
        if changePhoneTitle != title {
            changePhoneTitle = title
            settingsTableView.reloadRows(
                at: [IndexPath(row: SettingsCell.changePhone.rawValue, section: 0)],
                with: UITableView.RowAnimation.fade)
        }
    }
}


// MARK: - Private methods

extension SettingsViewController {
    private func registerCell() {
        let nib = UINib(nibName: "SettingsCell", bundle: nil)
        settingsTableView.register(nib, forCellReuseIdentifier: "settingsCell")
    }
    
    private func setDelegates() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    private func configureTableView() {
        settingsTableView.tableFooterView = UIView()
        settingsTableView.separatorStyle = .none
        settingsTableView.isScrollEnabled = false
    }
    
    func configureInterface() {
        signOutButton.setup(color: Theme.Button.Color.red, borderAlpha: 0.1)
    }
}
