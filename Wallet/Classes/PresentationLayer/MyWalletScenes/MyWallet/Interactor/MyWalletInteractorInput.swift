//
//  MyWalletInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol MyWalletInteractorInput: class {
    func getAccountWatcher() -> CurrentAccountWatcherProtocol
    func getAccounts() -> [Account]
    func refreshAccounts()
}
