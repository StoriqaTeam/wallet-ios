//
//  ChannelStorage.swift
//  Channels
//
//  Created by Даниил Мирошниченко on 27/10/2018.
//  Copyright © 2018 Даниил Мирошниченко. All rights reserved.
//

import Foundation


typealias ShortPollingChannel = Channel<String?>
typealias TxnUpadteChannel = Channel<[Transaction]>
typealias AccountsUpadteChannel = Channel<[Account]>

struct ChannelStorage {
    let shortPollingChannel: ShortPollingChannel = ShortPollingChannel(queue: .main)
    let txnUpadteChannel: TxnUpadteChannel = TxnUpadteChannel(queue: .main)
    let accountsUpadteChannel: AccountsUpadteChannel = AccountsUpadteChannel(queue: .main)
}
