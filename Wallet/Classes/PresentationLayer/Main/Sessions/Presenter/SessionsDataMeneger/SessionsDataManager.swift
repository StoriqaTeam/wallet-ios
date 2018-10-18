//
//  SessionsDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SessionsDataManagerDelegate: class {
    func deleteSession(_ session: Session)
}

class SessionDataManager: NSObject {
    
    weak var delegate: SessionsDataManagerDelegate!
    
    private var sessionsTableView: UITableView!
    private let kSessionCellIdentifier = "SessionCell"
    private let sessionDateSorter: SessionDateSorterProtocol
    private var sessions: [Session]
    
    init(sessions: [Session], sessionDateSorter: SessionDateSorterProtocol) {
        self.sessions = sessions
        self.sessionDateSorter = sessionDateSorter
        self.sessions = sessionDateSorter.sort(sessions: sessions)
    }
    
    
    func setTableView(_ view: UITableView) {
        sessionsTableView = view
        sessionsTableView.delegate = self
        sessionsTableView.dataSource = self
        registerXib()
    }
    
}


// MARK: - UItableViewDataSource

extension SessionDataManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sessions.isEmpty { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kSessionCellIdentifier, for: indexPath)
        let sessionCell = cell as! SessionTableViewCell
        sessionCell.configure(session: session)
        return sessionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return true
    }
}


// MARK: - UItableViewDelegate

extension SessionDataManager: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Terminate") { (_, indexPath) in
            let deletingSession = self.sessions[indexPath.row]
            self.sessions.remove(at: indexPath.row)
            if self.sessions.isEmpty {
                tableView.beginUpdates()
                let indexSet: IndexSet = [0, 1]
                tableView.deleteSections(indexSet, with: .fade)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
            
            if indexPath.section == 1 && indexPath.row == 0 {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate.deleteSession(deletingSession)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = section == 0 ? "LAST ACTIVITY" : "PREVIOUS ACTIVITY"
        return createHeaderView(with: title)
    }
}


// MARK: - Private methods

extension SessionDataManager {
    private func registerXib() {
        let nib = UINib(nibName: kSessionCellIdentifier, bundle: nil)
        sessionsTableView.register(nib, forCellReuseIdentifier: kSessionCellIdentifier)
    }
    
    private func createHeaderView(with title: String) -> UIView {
        let headerWidth = UIScreen.main.bounds.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 50))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 17, y: 4, width: headerWidth, height: 40))
        label.text = title.uppercased()
        label.textColor = Theme.Text.Color.captionGrey
        label.font = Theme.Font.smallText
        headerView.addSubview(label)
        
        return headerView
    }
}
