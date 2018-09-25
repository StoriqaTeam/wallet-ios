//
//  ContactsDataManager.swift
//  Wallet
//
//  Created by user on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ContactsDataManagerDelegate: class {
    func contactSelected(_ contact: Contact)
}

class ContactsDataManager: NSObject {
    weak var delegate: ContactsDataManagerDelegate?
    private var tableView: UITableView!
    private var contacts: [ContactsSection]
    private var placeHolderView: UIView?
    private let kContactCell = "ContactCell"
    
    init(contacts: [ContactsSection]) {
        self.contacts = contacts
        placeHolderView = nil
    }
    
    init(placeHolderView: UIView) {
        self.placeHolderView = placeHolderView
        contacts = [ContactsSection]()
    }
    
    func setTableView(_ view: UITableView) {
        tableView = view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = placeHolderView
        
        configTableView()
        registerXib()
    }
    
    func updateContacts(_ contacts: [ContactsSection]) {
        self.contacts = contacts
        placeHolderView = nil
        
        self.tableView.backgroundView = placeHolderView
        self.tableView.reloadData()
    }
    
    func updateEmpty(_ placeHolderView: UIView) {
        contacts.removeAll()
        self.placeHolderView = placeHolderView
        
        self.tableView.backgroundView = placeHolderView
        self.tableView.reloadData()
    }
    
}


//MARK: - UITableViewDataSource

extension ContactsDataManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        let contact = contacts[indexPath.section].contacts[indexPath.row]
        cell.config(contact: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 18, y: 24, width: 100, height: 22))
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = UIColor.darkText
        label.text = contacts[section].title
        label.sizeToFit()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 54))
        view.backgroundColor = .white
        view.addSubview(label)
        return view
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contacts.map({ return $0.title })
    }
}


//MARK: - UITableViewDelegate

extension ContactsDataManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.section].contacts[indexPath.row]
        delegate?.contactSelected(contact)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Private methods

extension ContactsDataManager {
    private func configTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView() //removing empty cells
    }
    
    private func registerXib() {
        let nib = UINib(nibName: kContactCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kContactCell)
    }
}
