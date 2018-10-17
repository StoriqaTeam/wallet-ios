//
//  CrashTrackerConfigurator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics


class CrashTrackerConfigurator: Configurable {
    func configure() {
        Fabric.with([Crashlytics.self])
    }
}
