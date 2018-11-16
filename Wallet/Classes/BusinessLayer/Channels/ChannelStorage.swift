//
//  ChannelStorage.swift
//  Channels
//
//  Created by Storiqa on 27/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


typealias ShortPollingChannel = Channel<String?>
typealias TxsUpdateChannel = Channel<[Transaction]>
typealias AccountsUpdateChannel = Channel<[Account]>
typealias FeeUpdateChannel = Channel<[Fee]>

struct ChannelStorage {
    let shortPollingChannel: ShortPollingChannel = ShortPollingChannel(queue: .main)
    let txsUpadteChannel: TxsUpdateChannel = TxsUpdateChannel(queue: .main)
    let accountsUpadteChannel: AccountsUpdateChannel = AccountsUpdateChannel(queue: .main)
    let feeUpadteChannel: FeeUpdateChannel = FeeUpdateChannel(queue: .main)
}
