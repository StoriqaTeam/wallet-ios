//
//  ChannelStorage.swift
//  Channels
//
//  Created by Даниил Мирошниченко on 27/10/2018.
//  Copyright © 2018 Даниил Мирошниченко. All rights reserved.
//

import Foundation


typealias ShortPollingChannel = Channel<String?>

struct ChannelStorage {
    let shortPollingChannel: ShortPollingChannel = Channel<String?>(queue: .main)
}
