//
//  TestConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 01/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class TestConfigurator: Configurable {
    
    let userDS = UserDataStoreService()
    
    func configure() {
        let user = userDS.getCurrentUser()
        print(user)
    }
    
}
