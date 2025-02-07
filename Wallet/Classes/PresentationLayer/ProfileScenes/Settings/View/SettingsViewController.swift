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
    //FIXME: hidden
    //    case changePhone
    case appInfo
    
    static var count = 3 // 4
}

class SettingsViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Settings
    
    var output: SettingsViewOutput!
    
    @IBOutlet private var settingsTableView: UITableView!
    @IBOutlet private var signOutButton: GradientButton!
    
    private var changePhoneTitle: String = ""
    private var hasChangePassword = true
    
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
            case SettingsCell.editProfile.rawValue: return LocalizedStrings.editProfile
            case SettingsCell.changePassword.rawValue where hasChangePassword: return LocalizedStrings.changePassword
                //FIXME: hidden
            //            case SettingsCell.changePhone.rawValue: return changePhoneTitle
            case SettingsCell.appInfo.rawValue: return LocalizedStrings.appInfo
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
        switch indexPath.row {
        case SettingsCell.changePassword.rawValue where !hasChangePassword:
            return 0.001
        default: break
        }
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case SettingsCell.editProfile.rawValue: output.editProfileSelected()
        case SettingsCell.changePassword.rawValue where hasChangePassword: output.changePasswordSelected()
            //FIXME: hidden
        //        case SettingsCell.changePhone.rawValue: output.changePhoneNumber()
        case SettingsCell.appInfo.rawValue: output.appInfoSelected()
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func setupInitialState(hasChangePassword: Bool) {
        setDelegates()
        registerCell()
        configureTableView()
        configureInterface()
        
        self.hasChangePassword = hasChangePassword
    }
    
    func setChangePhoneTitle(_ title: String) {
        
        //FIXME: hidden
        //        if changePhoneTitle != title {
        //            changePhoneTitle = title
        //            settingsTableView.reloadRows(
        //                at: [IndexPath(row: SettingsCell.changePhone.rawValue, section: 0)],
        //                with: UITableView.RowAnimation.fade)
        //        }
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
        signOutButton.setup(colors: [Theme.Color.Button.red.cgColor],
                            titleColor:  Theme.Color.Button.red)
        
        view.backgroundColor = Theme.Color.backgroundColor
        
        settingsTableView.backgroundColor = Theme.Color.backgroundColor
        settingsTableView.backgroundView?.backgroundColor = Theme.Color.backgroundColor
        settingsTableView.separatorStyle = .none
    }
}
