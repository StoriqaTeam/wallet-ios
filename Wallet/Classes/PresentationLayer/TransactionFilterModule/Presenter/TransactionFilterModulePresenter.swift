//
//  TransactionFilterModulePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionFilterPresenter {
    
    weak var view: TransactionFilterViewInput!
    weak var output: TransactionFilterModuleOutput?
    var interactor: TransactionFilterInteractorInput!
    var router: TransactionFilterRouterInput!
    
    private var transactionDateFilter: TransactionDateFilterProtocol
    
    init(transactionDateFilter: TransactionDateFilterProtocol) {
        self.transactionDateFilter = transactionDateFilter
    }
}


// MARK: - TransactionFilterModuleViewOutput

extension TransactionFilterPresenter: TransactionFilterViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
        configureViewWithFilter()
    }
    
    func setFilter() {
        view.dismiss()
    }
    
    func resetFilter() {
        transactionDateFilter.resetFilter()
    }
    
    func checkFilter() {
        if !transactionDateFilter.canApplyFilter() {
            transactionDateFilter.resetFilter()
        }
    }

    func didSelectFrom(date: Date) {
        transactionDateFilter.fromDate = date
        let validFilter = transactionDateFilter.canApplyFilter()
        view.buttonsChangedState(isEnabled: validFilter)
        
    }
    
    func didSelectTo(date: Date) {
        transactionDateFilter.toDate = date
        let validFilter = transactionDateFilter.canApplyFilter()
        view.buttonsChangedState(isEnabled: validFilter)
    }
}


// MARK: - TransactionFilterModuleInteractorOutput

extension TransactionFilterPresenter: TransactionFilterInteractorOutput {

}


// MARK: - TransactionFilterModuleModuleInput

extension TransactionFilterPresenter: TransactionFilterModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private methods

extension TransactionFilterPresenter {
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: "Filter")
    }
    
    private func configureViewWithFilter() {
        guard transactionDateFilter.canApplyFilter() else {
            view.buttonsChangedState(isEnabled: false)
            return
        }
        
        guard let fromDate = transactionDateFilter.fromDate else { return }
        guard let toDate = transactionDateFilter.toDate else { return }
        
        view.fillTextFileld(fromDate: fromDate, toDate: toDate)
        view.buttonsChangedState(isEnabled: true)
    }
}
