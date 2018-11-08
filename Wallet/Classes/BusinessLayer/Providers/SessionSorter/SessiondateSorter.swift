//
//  SessiondateSorter.swift
//  Wallet
//
//  Created by Storiqa on 18/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SessionDateSorterProtocol {
    func sort(sessions: [Session]) -> [Session]
}

class SessionDateSorter: SessionDateSorterProtocol {
    
    func sort(sessions: [Session]) -> [Session] {
        return sessions.sorted { $0.date >= $1.date }
    }
}
