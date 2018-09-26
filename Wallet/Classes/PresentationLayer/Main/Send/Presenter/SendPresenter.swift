//
//  SendPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendPresenter {
    
    weak var view: SendViewInput!
    weak var output: SendModuleOutput?
    var interactor: SendInteractorInput!
    var router: SendRouterInput!
}


// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {

    func viewIsReady() {
        view.setupInitialState()
        
        
        //FIXME: - delete this!
        let converterFactory = CurrecncyConverterFactory()
        let formatter = CurrencyFormatter()
        let sendProvider = SendTransactionBuilder(converterFactory: converterFactory, currencyFormatter: formatter)
        sendProvider.selectedAccount = Account(type: .stqBlack, cryptoAmount: "145,678,445.00", fiatAmount: "257,204.00 $", holderName: "Mushchinskii Dmitrii", currency: .stq)
        sendProvider.receiverCurrency = .btc
        sendProvider.amount = 100000
        ReceiverModule.create(sendProvider: sendProvider).present(from: view.viewController)
    }
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {

}


// MARK: - SendModuleInput

extension SendPresenter: SendModuleInput {

    var viewController: UIViewController {
        return view.viewController
    }
    
    func present() {
        view.present()
    }
    

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}
