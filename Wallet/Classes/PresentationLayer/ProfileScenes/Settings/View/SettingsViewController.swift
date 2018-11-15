//
//  SettingsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    var output: SettingsViewOutput!
    
    @IBOutlet private var settingsTableView: UITableView!
    @IBOutlet private var signOutButton: LightButton!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        output.signOutButtonTapped()
    }
    
}


// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = indexPath.row == 0 ? "Edit profile" : "Change password"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        guard let settingsCell = cell as? SettingsTableViewCell else { fatalError("Fail to cast cell") }
        settingsCell.configure(info: info)
        return settingsCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}


// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: output.editProfileSelected()
        case 1: output.changePasswordSelected()
        default:
            break
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
