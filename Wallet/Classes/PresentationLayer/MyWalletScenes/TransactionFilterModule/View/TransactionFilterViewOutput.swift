//
//  TransactionFilterModuleViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionFilterViewOutput: class {
    func viewIsReady()
    func didSelectFrom(date: Date)
    func didSelectTo(date: Date)
    func resetFilter()
    func setFilter()
    func checkFilter()
}
