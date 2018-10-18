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
    var date: Date
    let device: DeviceSession
}


// MARK: - RealmMappablee

extension Session: RealmMappable {
    typealias RealmType = RealmSession
    
    init(_ object: RealmSession) {
        date = Date()
        device = DeviceSession(string: object.device)
        
        let dateFormatter = sessionDateFormatter()
        date = dateFormatter.date(from: object.date) ?? Date(timeIntervalSince1970: 0)
    }
    
    func mapToRealmObject() -> RealmSession {
        let object = RealmSession()
        let dateFormatter = sessionDateFormatter()
        object.date = dateFormatter.string(from: date)
        object.device = device.rawValue
        
        return object
    }
}


// MARK: - Private methods

extension Session {
    private func sessionDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
