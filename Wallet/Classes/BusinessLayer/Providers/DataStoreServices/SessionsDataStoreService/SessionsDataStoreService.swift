//
//  SessionsDataStoreService.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SessionsDataStoreServiceProtocol {
    func getAllSessions() -> [Session]
    func saveSession(_ session: Session)
    func delete(_ session: Session)
    func deleteAllSessions()
}


class SessionsDataStoreService: RealmStorable<Session>, SessionsDataStoreServiceProtocol {
    
    func deleteAllSessions() {
        let sessions = getAllSessions()
        for session in sessions {
            delete(session)
        }
    }
    
    func getAllSessions() -> [Session] {
        return find()
    }
    
    func saveSession(_ session: Session) {
        save(session)
    }
    
    func delete(_ session: Session) {
        let date = session.date
        let dateFormatter = sessionDateFormatter()
        let primaryKey = dateFormatter.string(from: date)
        delete(primaryKey: primaryKey)
    }
}


// MARK: - Private methods

extension SessionsDataStoreService {
    private func sessionDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
