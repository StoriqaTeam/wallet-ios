//
//  Observer.swift
//  Channels
//
//  Created by Даниил Мирошниченко on 26/10/2018.
//  Copyright © 2018 Даниил Мирошниченко. All rights reserved.
//

import Foundation


class Observer<SignalData> {
    typealias CallBack = (SignalData) -> Void
    
    let id: Identifier
    private let callBack: CallBack
    
    init(id: Identifier, callback: @escaping CallBack) {
        self.id = id
        self.callBack = callback
    }
    
    convenience init(id: String, callback: @escaping CallBack) {
        self.init(id: Identifier(id), callback: callback)
    }
    
    func send(_ value: SignalData) {
        self.callBack(value)
    }
}


// MARK: - Hashable

extension Observer: Hashable {
    var hashValue: Int {
        return self.id.hashValue
    }
    
    static func == (_ lhs: Observer, _ rhs: Observer) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
