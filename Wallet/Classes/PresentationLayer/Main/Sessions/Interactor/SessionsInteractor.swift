//
//  SessionsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SessionsInteractor {
    weak var output: SessionsInteractorOutput!
    
    private let sessionsDataStore: SessionsDataStoreServiceProtocol
    
    init(sessionsDataStoreService: SessionsDataStoreServiceProtocol) {
        self.sessionsDataStore = sessionsDataStoreService
    }

}


// MARK: - SessionsInteractorInput

extension SessionsInteractor: SessionsInteractorInput {
    func deleteAllSessions() {
        sessionsDataStore.deleteAll()
    }
    
    func delete(session: Session) {
        sessionsDataStore.delete(session)
    }
    
    func getSessions() -> [Session] {
        return sessionsDataStore.getAllSessions()
    }
}
