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
    weak var mainTabBar: UITabBarController!
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let currencyImageProvider: CurrencyImageProviderProtocol
    private var contactsDataManager: ContactsDataManager!
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         currencyImageProvider: CurrencyImageProviderProtocol) {
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
        self.currencyImageProvider = currencyImageProvider
    }
}


// MARK: - ReceiverViewOutput

extension ReceiverPresenter: ReceiverViewOutput {
    
    func configureInput() {
        let contacts = interactor.getContact()
        
        guard !contacts.isEmpty else { return }
        interactor.searchContact(text: contacts[0].familyName)
        view.setNextButtonHidden(false)
        view.setInput(contacts[0].mobile)
    }
    
    func nextButtonPressed() {
        let builder = interactor.getSendTransactionBuilder()
        router.showPaymentFee(sendTransactionBuilder: builder,
                              from: view.viewController,
                              tabBar: mainTabBar)
    }
    
    func scanButtonPressed() {
        let builder = interactor.getSendTransactionBuilder()
        interactor.setScannedDelegate(self)
        router.showScanner(sendTransactionBuilder: builder, from: view.viewController)
    }
    
    func editButtonPressed() {
        view.popToRoot()
    }
    
    func inputDidChange(_ input: String) {
        
        //TODO: нужны проверки, валидный ли номер, чтобы активировать кнопку.
        //Пока кнопка активируется только по клику на контакт и скану
        view.setNextButtonHidden(true)
        interactor.searchContact(text: input)
    }
    
    
    func contactsTableView(_ tableView: UITableView) {
        contactsDataManager = ContactsDataManager()
        contactsDataManager.setTableView(tableView)
        contactsDataManager.delegate = self
        interactor.fetchContacts()
    }
    
    func viewIsReady() {
        
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let accountCurrency = interactor.getSelectedAccount().currency
        let amountString = getStringFrom(amount: amount, currency: currency)
        let amountStringInTxCurrency = getStringInTransactionCurrency(amount: amount, accountCurrency: accountCurrency)
        let currencyImage = currencyImageProvider.mediumImage(for: currency)
        
        let appearence = SendingHeaderData(amount: amountString,
                                           amountInTransactionCurrency: amountStringInTxCurrency,
                                           currencyImage: currencyImage)
        
        view.setupInitialState(apperance: appearence)
        view.setNextButtonHidden(true)
    }
    
    func willMoveToParentVC() {
        view.viewController.setWhiteTextNavigationBar()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkTextNavigationBar()
        
    }
    
}


// MARK: - ReceiverInteractorOutput

extension ReceiverPresenter: ReceiverInteractorOutput {
    
    func updateContacts(_ contacts: [ContactsSection]) {
        contactsDataManager.updateContacts(contacts)
    }
    
    func updateEmpty(placeholderImage: UIImage, placeholderText: String) {
        contactsDataManager.updateEmpty(placeholderImage: placeholderImage,
                                        placeholderText: placeholderText)
    }
    

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


// MARK: - Private methods

extension ReceiverPresenter {
    private func getStringFrom(amount: Decimal?, currency: Currency) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: currency)
        return formatted
    }
    
    private func getStringInTransactionCurrency(amount: Decimal?, accountCurrency: Currency) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        let receiverCurrency = interactor.getReceiverCurrency()
        let currencyConverter = converterFactory.createConverter(from: receiverCurrency)
        let converted = currencyConverter.convert(amount: amount, to: accountCurrency)
        let formatted = currencyFormatter.getStringFrom(amount: converted, currency: accountCurrency)
        return "=" + formatted
    }
}
