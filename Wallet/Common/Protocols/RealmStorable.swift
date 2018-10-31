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
    
    private let realm: Realm
    
    init(realmFolder: URL? = nil) {
        if let realmFolder = realmFolder {
            let realm = try! Realm(fileURL: realmFolder)
            self.realm = realm
        } else {
            self.realm = try! Realm()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
        notificationToken = nil
    }
    
    func observe(updateHandler: @escaping ([PlainType]) -> Void) {
        let objects = realm.objects(PlainType.RealmType.self)
        notificationToken?.invalidate()
        notificationToken = objects.observe { _ in
            updateHandler(objects.map { PlainType($0) })
        }
    }
    
    func find() -> [PlainType] {
        return realm.objects(PlainType.RealmType.self).compactMap { PlainType($0) }
    }
    
    func find(_ predicateString: String) -> [PlainType] {
        return realm.objects(PlainType.RealmType.self)
            .filter(predicateString)
            .compactMap { PlainType($0) }
    }
    
    func findOne(_ predicateString: String) -> PlainType? {
        return realm.objects(PlainType.RealmType.self).filter(predicateString).compactMap { PlainType($0) }.first
    }
    
    func save(_ model: PlainType) {
        try! realm.write {
            realm.add(model.mapToRealmObject(), update: true)
        }
    }
    
    func save(_ models: [PlainType]) {
        try! realm.write {
            realm.add(models.map({ $0.mapToRealmObject() }), update: true)
        }
    }
    
    func delete(primaryKey: String) {
        guard let realmObjectPrimaryKey = PlainType.RealmType.self.primaryKey() else { return }
        let predicateString = "\(realmObjectPrimaryKey) == '\(primaryKey)'"
        let objectToDelete = realm.objects(PlainType.RealmType.self).filter(predicateString)
        
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
    
    func delete(primaryKey: Int) {
        guard let realmObjectPrimaryKey = PlainType.RealmType.self.primaryKey() else { return }
        let predicateString = "\(realmObjectPrimaryKey) == \(primaryKey)"
        let objectToDelete = realm.objects(PlainType.RealmType.self).filter(predicateString)
        
        try! realm.write {
            realm.delete(objectToDelete)
        }
    }
    
    func resetAllDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
