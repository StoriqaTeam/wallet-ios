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
typealias OrderExpiredChannel = Channel<Order?>
typealias OrderTickChannel = Channel<Int>
typealias UserUpdateChannel = Channel<User>


struct ChannelStorage {
    let shortPollingChannel: ShortPollingChannel = ShortPollingChannel(queue: .main)
    let txsUpadteChannel: TxsUpdateChannel = TxsUpdateChannel(queue: .main)
    let accountsUpadteChannel: AccountsUpdateChannel = AccountsUpdateChannel(queue: .main)
    let orderExpiredChannel: OrderExpiredChannel = OrderExpiredChannel(queue: .main)
    let orderTickChannel: OrderTickChannel = OrderTickChannel(queue: .main)
    let userUpdateChannel: UserUpdateChannel = UserUpdateChannel(queue: .main)
}
