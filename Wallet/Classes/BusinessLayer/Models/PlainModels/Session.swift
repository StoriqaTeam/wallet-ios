//
//  Session.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum DeviceSession: String {
    case iphone
    case desktop
    
    init(string: String) {
        switch string {
        case "iphone":
            self = .iphone
        default:
            self = .desktop
        }
    }
}

struct Session {
    let date: Date
    let device: DeviceSession
}


// MARK: - RealmMappablee

extension Session {
    typealias RealmType = RealmSession
    
    init(_ object: RealmSession) {
        date = Date(timeIntervalSince1970: object.date)
        device = DeviceSession(string: object.device)
    }
    
    func mapToRealmObject() -> RealmSession {
        let object = RealmSession()
        
        object.date = Double(date.timeIntervalSince1970)
        object.device = device.rawValue
        
        return object
    }
}
