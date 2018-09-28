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
    
    func nextButtonPressed() {
        let sendProvider = interactor.getSendTransactionBuilder()
        router.showPaymentFee(sendProvider: sendProvider, from: view.viewController)
    }
    
    func scanButtonPressed() {
        let sendProvider = interactor.getSendTransactionBuilder()
        interactor.setScannedDelegate(self)
        router.showScanner(sendProvider: sendProvider, from: view.viewController)
    }
    
    func editButtonPressed() {
        //TODO: action for edit button?
    }
    
    func inputDidChange(_ input: String) {
        //TODO: нужны проверки, валидный ли номер, чтобы активировать кнопку. Пока кнопка активируется только по клику на контакт и скану
        view.setNextButtonHidden(true)
        interactor.searchContact(text: input)
    }
    
    
    func contactsTableView(_ tableView: UITableView) {
        interactor.createContactsDataManager(with: tableView)
    }
    
    func viewIsReady() {
        let apperance = interactor.getHeaderApperance()
        view.setupInitialState(apperance: apperance)
        view.setNextButtonHidden(true)
        interactor.setContactsDataManagerDelegate(self)
    }
    
    func willMoveToParentVC() {
        view.viewController.setWhiteTextNavigationBar()
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
        interactor.setContact(contact)
        view.setInput(contact.mobile)
        view.setNextButtonHidden(false)
    }
    
}


// MARK: - QRScannerDelegate

extension ReceiverPresenter: QRScannerDelegate {
    
    func didScanAddress(_ address: String) {
        view.setInput(address)
        view.setNextButtonHidden(false)
    }
    
}



