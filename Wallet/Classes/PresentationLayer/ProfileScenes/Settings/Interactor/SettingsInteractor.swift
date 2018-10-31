//
//  SettingsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SettingsInteractor {
    weak var output: SettingsInteractorOutput!
    
    private let sessionsDataStore: SessionsDataStoreServiceProtocol
    
    init(sessionsDataStore: SessionsDataStoreServiceProtocol) {
        self.sessionsDataStore = sessionsDataStore
    }
}


// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
  
    func getSessionsCount() -> Int {
        let sessions = sessionsDataStore.getAllSessions()
        return sessions.count
    }
}
