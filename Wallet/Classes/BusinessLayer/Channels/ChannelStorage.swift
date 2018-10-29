//
//  ChannelStorage.swift
//  Channels
//
//  Created by Даниил Мирошниченко on 27/10/2018.
//  Copyright © 2018 Даниил Мирошниченко. All rights reserved.
//

import Foundation


typealias ShortPollingChannel = Channel<String?>
typealias TxsUpdateChannel = Channel<[Transaction]>
typealias AccountsUpdateChannel = Channel<[Account]>

struct ChannelStorage {
    let shortPollingChannel: ShortPollingChannel = ShortPollingChannel(queue: .main)
    let txsUpadteChannel: TxsUpdateChannel = TxsUpdateChannel(queue: .main)
    let accountsUpadteChannel: AccountsUpdateChannel = AccountsUpdateChannel(queue: .main)
}
