//
//  CrashTrackerConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Sentry


class CrashTrackerConfigurator: Configurable {
    func configure() {
        do {
            Client.shared = try Client(dsn: "https://d36155cf273d4b478340cb0a6cddee28@debug.stq.cloud/23")
            try Client.shared?.startCrashHandler()
        } catch let error {
            print("\(error)")
        }
        
    }
}
