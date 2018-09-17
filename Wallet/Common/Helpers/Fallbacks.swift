//
//  Fallback.swift
//  Wallet
//
//  Created by user on 27.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class Fallback {
    //TODO: сюда же парсинг ответа от сервера
    private init() {}
    
    static func couldNotInstantiateViewController(identifier: String, storyBoard: String, fatal: Bool) {
        let msg = "No ViewController with identifier '\(identifier)' on '\(storyBoard)' storyBoard"
        
        if fatal {
            assertionFailure(msg)
        } else {
            log.error(msg)
        }
    }
}
