//
//  Channel.swift
//  Channels
//
//  Created by Storiqa on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class Channel<SignalData> {
    private let queue: DispatchQueue
    private var observers: Set<Observer<SignalData>>
    
    init(queue: DispatchQueue) {
        self.queue = queue
        self.observers = Set<Observer<SignalData>>()
    }
    
    func addObserver(_ observer: Observer<SignalData>) {
        if observers.contains(observer) {
            observers.remove(observer)
            observers.insert(observer)
        } else {
            observers.insert(observer)
        }
    }
    
    func send(_ value: SignalData) {
        queue.async {
            for observer in self.observers {
                observer.send(value)
            }
        }
    }
    
    func removeObserver(withId observerId: Identifier) {
        if let observer = observers.first(where: { $0.id == observerId }) {
            removeObserver(observer)
        }
    }
    
    func removeObserver(_ observer: Observer<SignalData>) {
        _ = observers.remove(observer)
    }
    
    func removeObserver(withId observerId: String) {
        self.removeObserver(withId: Identifier(observerId))
    }
}
