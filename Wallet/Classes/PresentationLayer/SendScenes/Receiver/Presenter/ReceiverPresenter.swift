//
//  ReceiverPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverPresenter {
    
    typealias Localization = Strings.Receiver
    
    weak var view: ReceiverViewInput!
    weak var output: ReceiverModuleOutput?
    var interactor: ReceiverInteractorInput!
    var router: ReceiverRouterInput!
    weak var mainTabBar: UITabBarController!
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let currencyImageProvider: CurrencyImageProviderProtocol
    private let contactsMapper: ContactsMapper
    private let contactsSorter: ContactsSorterProtocol
    private var contactsDataManager: ContactsDataManager!
    
    private var contacts: [ContactDisplayable] = []
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         currencyImageProvider: CurrencyImageProviderProtocol,
         contactsMapper: ContactsMapper,
         contactsSorter: ContactsSorterProtocol) {
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
        self.currencyImageProvider = currencyImageProvider
        self.contactsMapper = contactsMapper
        self.contactsSorter = contactsSorter
    }
}


// MARK: - ReceiverViewOutput

extension ReceiverPresenter: ReceiverViewOutput {
    
    func configureInput() {
        guard let contact = interactor.getContact() else { return }
        
        searchContact(text: contact.familyName)
        view.setNextButtonHidden(false)
        view.setInput(contact.id)
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
        searchContact(text: input)
    }
    
    
    func contactsTableView(_ tableView: UITableView) {
        contactsDataManager = ContactsDataManager()
        contactsDataManager.setTableView(tableView)
        contactsDataManager.delegate = self
        
        interactor.loadContacts()
    }
    
    func viewIsReady() {
        let amount = interactor.getAmount()
        let receiverCurrency = interactor.getReceiverCurrency()
        let accountCurrency = interactor.getSelectedAccount().currency
        let amountString = getStringFrom(amount: amount, currency: receiverCurrency)
        let amountStringInTxCurrency = getStringInTransactionCurrency(amount: amount, accountCurrency: accountCurrency)
        let currencyImage = currencyImageProvider.mediumImage(for: receiverCurrency)
        
        let appearence = SendingHeaderData(amount: amountString,
                                           amountInTransactionCurrency: amountStringInTxCurrency,
                                           currencyImage: currencyImage)
        let canScan = receiverCurrency != .fiat
        
        view.setupInitialState(apperance: appearence, canScan: canScan)
        view.setNextButtonHidden(true)
        configureNavigationBar()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkNavigationBarButtons()
    }
    
}


// MARK: - ReceiverInteractorOutput

extension ReceiverPresenter: ReceiverInteractorOutput {
    
    func updateContacts(_ contacts: [Contact]) {
        let displayable = contacts.map { contactsMapper.map(from: $0) }
        self.contacts = displayable
        let sorted = contactsSorter.sort(contacts: displayable)
        
        // TODO: empty contact list message
        if sorted.isEmpty {
            updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                        placeholderText: Localizations.emptyListPlaceholder)
        } else {
            contactsDataManager.updateContacts(sorted)
        }
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
    
    func contactSelected(_ contact: ContactDisplayable) {
        if contact.cryptoAddress != nil {
            interactor.setContact(contact)
            view.setInput(contact.id)
            view.setNextButtonHidden(false)
        } else {
            // TODO: what to show when no address
        }
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
    private func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: Localizations.screenTitle)
    }
    
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
        return "≈" + formatted
    }
    
    private func searchContact(text: String) {
        let filteredSections = contactsSorter.searchContact(text: text, contacts: contacts)
        
        if filteredSections.isEmpty {
            updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                        placeholderText: Localizations.noSuchNumberPlaceholder)
        } else {
            contactsDataManager.updateContacts(filteredSections)
        }
    }
}
