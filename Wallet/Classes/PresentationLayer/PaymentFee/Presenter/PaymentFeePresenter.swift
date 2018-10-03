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
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol, converterFactory: CurrecncyConverterFactoryProtocol) {
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
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
        view.setSubtotal(subtotal)
        
        let isEnoughFunds = interactor.isEnoughFunds()
        view.setErrorHidden(isEnoughFunds)
    }
    
    func sendButtonPressed() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let amountString = getStringfrom(amount: amount, currency: currency)
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
        let amountString = getStringfrom(amount: amount, currency: currency)
        let amountStringInTxCurrency = getStringInTransactionCurrency(amount: amount, accountCurrency: accountCurrency)
        let opponentType = interactor.getOpponent()
        
        let header = SendingHeaderData(amount: amountString,
                                       amountInTransactionCurrency: amountStringInTxCurrency,
                                       currencyImage: currency.mediumImage)
        
        
        let apperance = paymentFeeScreen(header: header, opponentType: opponentType)
        view.setupInitialState(apperance: apperance)
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func willMoveToParentVC() {
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

}


// MARK: - PaymentFeeInteractorOutput

extension PaymentFeePresenter: PaymentFeeInteractorOutput {

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
        //TODO: send transaction
        let _ = interactor.createTransaction()
    }
    
}


// MARK: - Private methods

extension PaymentFeePresenter {
    private func getStringfrom(amount: Decimal?, currency: Currency) -> String {
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
    
    private func paymentFeeScreen(header: SendingHeaderData, opponentType: OpponentType) ->  PaymentFeeScreenData{
        let address: String
        let receiverName: String
        switch opponentType {
        case .contact(let contact):
            //TODO: будем получать?
            address = "test address"
            receiverName = contact.name
        case .address(let addr):
            address = addr
            receiverName = "Receiver Name"
        }
        
        return PaymentFeeScreenData(header: header,
                                    address: address,
                                    receiverName: receiverName,
                                    paymentFeeValuesCount: interactor.getFeeWaitCount())
    }
}



