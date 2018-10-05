//
//  MyWalletInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol MyWalletInteractorInput: class {
    func accountsCount() -> Int 
    func accountModel(for index: Int) -> AccountDisplayable
    func getAccountWatcher() -> CurrentAccountWatcherProtocol
}
