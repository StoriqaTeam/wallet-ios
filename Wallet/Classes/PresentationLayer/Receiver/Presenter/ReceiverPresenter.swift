//
//  ReceiverPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverPresenter {
    
    weak var view: ReceiverViewInput!
    weak var output: ReceiverModuleOutput?
    var interactor: ReceiverInteractorInput!
    var router: ReceiverRouterInput!
    
}


// MARK: - ReceiverViewOutput

extension ReceiverPresenter: ReceiverViewOutput {
    func scanButtonPressed() {
        
    }
    
    func editButtonPressed() {
        //TODO: action for edit button?
        view.dismiss()
    }
    
    func inputDidChange(_ input: String) {
        interactor.searchContact(text: input)
    }
    
    
    func contactsTableView(_ tableView: UITableView) {
        interactor.createContactsDataManager(with: tableView)
    }
    
    func viewIsReady() {
        view.setupInitialState(amount: "0.000000 BTC", convertedAmount: "00000.00 STQ")
        interactor.setContactsDataManagerDelegate(self)
    }

}


// MARK: - ReceiverInteractorOutput

extension ReceiverPresenter: ReceiverInteractorOutput {

}


// MARK: - ReceiverModuleInput

extension ReceiverPresenter: ReceiverModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - ReceiverInteractorOutput

extension ReceiverPresenter: ContactsDataManagerDelegate {
    
    func contactSelected(_ contact: Contact) {
        //TODO: address??
        view.setInput(contact.mobile)
    }
    
}


