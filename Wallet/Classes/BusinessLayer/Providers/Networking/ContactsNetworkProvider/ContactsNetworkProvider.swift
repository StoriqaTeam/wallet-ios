//
//  ContactsNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ContactsNetworkProviderProtocol: class {
    func getContacts(ids: [String], completion: (Result<[String: String]>) -> Void)
}

class FakeContactsNetworkProvider: ContactsNetworkProviderProtocol {
    private var addresses = [
        "1QC8Wax1H4obQAo3FE1cawXgzwy7GZNd6V",
        "1EStjAD37Xc18ynaF5dti468AZfM7924HK",
        "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD",
        "1AVLzTVxCvbTa37ThqEPcTkjmuwpw4uCyY",
        "0xC6A9759C9A8Ede6698CF33E709907b6F9c502aA8",
        "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
        "0x39d7647073DD8FC590960930d883880e34052ee5",
        "0x9Cc539183De54759261Ef0ee9B3Fe91AEB85407F"]
    
    func getContacts(ids: [String], completion: (Result<[String: String]>) -> Void) {
        var fakeResult = [String: String]()
        
        for identifier in ids {
            if Bool.random() {
                fakeResult[identifier] = addresses.randomElement()
            }
        }
        
        let result = Result.success(fakeResult)
        completion(result)
    }
}
