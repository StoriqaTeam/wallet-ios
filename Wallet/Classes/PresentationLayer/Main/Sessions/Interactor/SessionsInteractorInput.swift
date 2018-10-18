//
//  SessionsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SessionsInteractorInput: class {
    func getSessions() -> [Session]
    func delete(session: Session)
    func deleteAllSessions()
}
