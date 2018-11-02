//
//  PaymentFeePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeePresenter {
    
    weak var view: PaymentFeeViewInput!
    weak var output: PaymentFeeModuleOutput?
    var interactor: PaymentFeeInteractorInput!
    var router: PaymentFeeRouterInput!
    weak var mainTabBar: UITabBarController!
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let currencyImageProvider: CurrencyImageProviderProtocol
    
    private var storiqaLoader: StoriqaLoader!
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         currencyImageProvider: CurrencyImageProviderProtocol) {
        self.currencyFormatter = currencyFormatter
        self.currencyImageProvider = currencyImageProvider
    }
    
}


// MARK: - PaymentFeeViewOutput

extension PaymentFeePresenter: PaymentFeeViewOutput {
    func newFeeSelected(_ index: Int) {
        interactor.setPaymentFee(index: index)
        
        let (fee, wait) = interactor.getFeeAndWait()
        view.setPaymentFee(fee)
        view.setMedianWait(wait)
        
        let subtotal = interactor.getSubtotal()
        let accountCurrency = interactor.getSelectedAccount().currency
        let subtotalStr = getStringFrom(amount: subtotal, currency: accountCurrency)
        view.setSubtotal(subtotalStr)
        
        let isEnoughFunds = interactor.isEnoughFunds()
        view.setErrorHidden(isEnoughFunds)
    }
    
    func sendButtonPressed() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let amountString = getStringFrom(amount: amount, currency: currency)
        let address = interactor.getAddress()
        
        router.showConfirm(amount: amountString,
                           address: address,
                           popUpDelegate: self,
                           from: view.viewController)
    }
    
    func editButtonPressed() {
        view.popToRoot()
    }
    
    func viewIsReady() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let accountCurrency = interactor.getSelectedAccount().currency
        let amountString = getStringFrom(amount: amount, currency: currency)
        let convertedAmount = interactor.getConvertedAmount()
        let amountStringInTxCurrency = "≈" + getStringFrom(amount: convertedAmount, currency: accountCurrency)
        let opponentType = interactor.getOpponent()
        let currencyImage = currencyImageProvider.mediumImage(for: currency)
        
        let header = SendingHeaderData(amount: amountString,
                                       amountInTransactionCurrency: amountStringInTxCurrency,
                                       currencyImage: currencyImage)
        
        
        let apperance = paymentFeeScreen(header: header, opponentType: opponentType)
        view.setupInitialState(apperance: apperance)
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        addLoader()
    }
    
    func willMoveToParentVC() {
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}


// MARK: - PaymentFeeInteractorOutput

extension PaymentFeePresenter: PaymentFeeInteractorOutput {
    func sendTxFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showConfirmFailed(message: message, from: view.viewController)
    }
    
    func sendTxSucceed() {
        storiqaLoader.stopLoader()
        router.showConfirmSucceed(popUpDelegate: self, from: view.viewController)
    }
}


// MARK: - PaymentFeeModuleInput

extension PaymentFeePresenter: PaymentFeeModuleInput {
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension PaymentFeePresenter: PopUpSendConfirmVMDelegate {
    func confirmTransaction() {
        storiqaLoader.startLoader()
        interactor.sendTransaction()
    }
}

// MARK: - PopUpRegistrationSuccessVMDelegate

extension PaymentFeePresenter: PopUpSendConfirmSuccessVMDelegate {
    func okButtonPressed() {
        interactor.clearBuilder()
        view.popToRoot()
    }
}


// MARK: - Private methods

extension PaymentFeePresenter {
    private func getStringFrom(amount: Decimal?, currency: Currency) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: currency)
        return formatted
    }
    
    private func paymentFeeScreen(header: SendingHeaderData, opponentType: OpponentType) -> PaymentFeeScreenData {
        let address: String
        let receiverName: String
        switch opponentType {
        case .contact(let contact):
            //TODO: будем получать?
            address = "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD"
            receiverName = contact.name
        case .address(let addr):
            address = addr
            receiverName = "-"
        case .txAccount:
            fatalError("TransactionAccount is impossible on send")
        }
        
        return PaymentFeeScreenData(header: header,
                                    address: address,
                                    receiverName: receiverName,
                                    paymentFeeValuesCount: interactor.getFeeWaitCount())
    }
    
    private func addLoader() {
        guard let parentView = view.viewController.navigationController?.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
}
