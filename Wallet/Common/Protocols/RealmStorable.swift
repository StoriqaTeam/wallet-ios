//
//  RealmStorable.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 01/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable force_try

import Foundation
import RealmSwift


class RealmStorable<PlainType: RealmMappable> {
    var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
        notificationToken = nil
    }
    
    func observe(updateHandler: @escaping ([PlainType]) -> Void) {
        let realm = try! Realm()
        let objects = realm.objects(PlainType.RealmType.self)
        notificationToken?.invalidate()
        notificationToken = objects.observe { _ in
            updateHandler(objects.map { PlainType($0) })
        }
    }
    
    func find() -> [PlainType] {
        let realm = try! Realm()
        return realm.objects(PlainType.RealmType.self).compactMap { PlainType($0) }
    }
    
    func find(_ predicateString: String) -> [PlainType] {
        let realm = try! Realm()
        return realm.objects(PlainType.RealmType.self)
            .filter(predicateString)
            .compactMap { PlainType($0) }
    }
    
    func findOne(_ predicateString: String) -> PlainType? {
        let realm = try! Realm()
        return realm.objects(PlainType.RealmType.self).filter(predicateString).compactMap { PlainType($0) }.first
    }
    
    func save(_ model: PlainType) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(model.mapToRealmObject(), update: true)
        }
    }
    
    func save(_ models: [PlainType]) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(models.map({ $0.mapToRealmObject() }), update: true)
        }
    }
    
    func deleteAll() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
}
