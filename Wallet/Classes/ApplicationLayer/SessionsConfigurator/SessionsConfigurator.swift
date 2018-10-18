//
//  SessionsConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SessionsConfigurator: Configurable {
    
    private let sessionsDataStore: SessionsDataStoreServiceProtocol
    
    init(sessionsDataStore: SessionsDataStoreService) {
        self.sessionsDataStore = sessionsDataStore
    }
    
    func configure() {
        saveCurrentSession()
    }
}


// MARK: - Private methods

extension SessionsConfigurator {
    private func saveCurrentSession() {
        let timestamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timestamp)
        let decice = DeviceSession.iphone
        
        let session = Session(date: date, device: decice)
        sessionsDataStore.saveSession(session)
    }
}
