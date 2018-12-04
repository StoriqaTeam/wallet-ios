//
//  SessionsViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsViewController: UIViewController {

    var output: SessionsViewOutput!

    @IBOutlet weak var sessionsTableView: UITableView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        output.sessionDataManager(sessionsTableView)
    }
    
    
    @objc func trashButtonTapped() {
        // FIXME: msg
        
        showAlert(title: "", message: "Do you want to delete all sessions?") {
            self.output.deleteAllSessions()
        }
    }
}


// MARK: - SessionsViewInput

extension SessionsViewController: SessionsViewInput {
    
    func setupInitialState() {
        addTrashButton()
    }
}


// MARK: - Private methods

extension SessionsViewController {
    private func addTrashButton() {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                             target: self,
                                             action: #selector(trashButtonTapped))
        navigationItem.rightBarButtonItem = trashButton
    }
    
    
}
