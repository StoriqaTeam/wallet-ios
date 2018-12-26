//
//  SessionsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionsPresenter {
    
    weak var view: SessionsViewInput!
    weak var output: SessionsModuleOutput?
    var interactor: SessionsInteractorInput!
    var router: SessionsRouterInput!
    
    private var dataManager: SessionDataManager!
    private let sessionDateSorter: SessionDateSorterProtocol
    
    init(sessionDateSorter: SessionDateSorterProtocol) {
        self.sessionDateSorter = sessionDateSorter
    }
    
}


// MARK: - SessionsViewOutput

extension SessionsPresenter: SessionsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavigationBar()
    }
    
    func sessionDataManager(_ tableView: UITableView) {
        let sessions = interactor.getSessions()
        let sessionsDataManager = SessionDataManager(sessions: sessions, sessionDateSorter: sessionDateSorter)
        
        sessionsDataManager.setTableView(tableView)
        dataManager = sessionsDataManager
        sessionsDataManager.delegate = self
    }
    
    func deleteAllSessions() {
        interactor.deleteAllSessions()
        view.dismiss()
    }

}


// MARK: - SessionsInteractorOutput

extension SessionsPresenter: SessionsInteractorOutput {

}


// MARK: - SessionsModuleInput

extension SessionsPresenter: SessionsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - SessionDataManagerDelegate

extension SessionsPresenter: SessionsDataManagerDelegate {
    
    func deleteSession(_ session: Session) {
        interactor.delete(session: session)
    }
}


// MARK: - Private methods

extension SessionsPresenter {
    func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = "Sessions"
    }
}
