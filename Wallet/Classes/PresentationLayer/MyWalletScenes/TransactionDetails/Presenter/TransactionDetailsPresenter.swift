//
//  TransactionDetailsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import UIKit


class TransactionDetailsPresenter {
    typealias LocalizedStrings = Strings.TransactionDetails
    
    weak var view: TransactionDetailsViewInput!
    weak var output: TransactionDetailsModuleOutput?
    var interactor: TransactionDetailsInteractorInput!
    var router: TransactionDetailsRouterInput!
    
    private var blockchainExplorerLinkGenerator: BlockchainExplorerLinkGeneratorProtocol
    private var transactionLink: URL?
    private var storiqaAlertHandler: StoriqaAlertHandler?
    
    init(blockchainExplorerLinkGenerator: BlockchainExplorerLinkGeneratorProtocol) {
        self.blockchainExplorerLinkGenerator = blockchainExplorerLinkGenerator
    }
    
}


// MARK: - TransactionDetailsViewOutput

extension TransactionDetailsPresenter: TransactionDetailsViewOutput {
    
    func viewIsReady() {
        let transaction = interactor.getTransaction()
        configureNavigationBar(transaction: transaction)
        view.setupInitialState(transaction: transaction)
        fetchTxHashes(transaction: transaction.transaction)
    }

    func viewWillAppear() {}
    
    func addressTapped(_ address: String) {
        UIPasteboard.general.string = address
        storiqaAlertHandler = StoriqaAlertHandler(parentView: view.viewController.view)
        storiqaAlertHandler?.showAlert(title: LocalizedStrings.addressCopiedMessage,
                                       message: "",
                                       alertType: .success,
                                       duration: 2)
    }
    
    func viewInBlockchain() {
        guard let url = transactionLink else { return }
        UIApplication.shared.open(url)
    }
    
}


// MARK: - TransactionDetailsInteractorOutput

extension TransactionDetailsPresenter: TransactionDetailsInteractorOutput {

}


// MARK: - TransactionDetailsModuleInput

extension TransactionDetailsPresenter: TransactionDetailsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private methods

extension TransactionDetailsPresenter {
    private func configureNavigationBar(transaction: TransactionDisplayable) {
        let title = transaction.direction == .receive ? LocalizedStrings.navigationBarTitleDeposit : LocalizedStrings.navigationBarTitleSent
        view.viewController.title = title
        view.viewController.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func fetchTxHashes(transaction: Transaction) {
        guard let hash = transaction.blockchainIds.first else {
            view.setupViewInBlockchainButtonVisibility(isVisible: false)
            return
        }
        
        let title = LocalizedStrings.viewOnExplorer
        let explorer = getExplorer(from: transaction)
        
        transactionLink = blockchainExplorerLinkGenerator.getLink(explorer: explorer, transactionHash: hash)
        view.setupBlockchainButton(title: title+explorer.rawValue)
        view.setupViewInBlockchainButtonVisibility(isVisible: true)
    }
    
    private func getExplorer(from transaction: Transaction) -> BlockchainExplorer {
        return transaction.fromCurrency == .btc ? .Blockcypher : .Etherscan
    }
}
