//
//  OrderHandler.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol OrderObserverDelegate: class {
    func updateExpired(seconds: Int)
}


protocol OrderObserverProtocol {
    func setNewOrder(order: Order)
    func isAliveCurrentOrder() -> Bool
    func getCurrentRate() -> Decimal?
    func getCurrentCurrencies() -> OrderCurrencies?
    func getCurrentOrderId() -> String?
    func invalidateOrder()
    
    func setDelegate(obj: OrderObserverDelegate)
}


class OrderObserver: OrderObserverProtocol {
    
    private var currentOrder: Order?
    private var elapsedTimer: Timer?
    
    weak var delegate: OrderObserverDelegate?
    private var expiredOrderOutputChannel: OrderExpiredChannel?
    
    init(outputChannel: OrderExpiredChannel) {
        self.expiredOrderOutputChannel = outputChannel
    }
    
    
    // MARK: - OrderObserverProtocol

    func setNewOrder(order: Order) {
        currentOrder = order
        updateElapsedTimer()
    }
    
    func isAliveCurrentOrder() -> Bool {
        guard let order = currentOrder else { return false }
        return order.elapsedTime() > 0
    }
    
    func setDelegate(obj: OrderObserverDelegate) {
        self.delegate = obj
    }
    
    func getCurrentRate() -> Decimal? {
        guard let order = currentOrder else { return nil }
        return order.getOrderRateValue()
        
    }
    
    func getCurrentCurrencies() -> OrderCurrencies? {
        guard let order = currentOrder else { return nil }
        return order.getOrderCurrencies()
    }
    
    func getCurrentOrderId() -> String? {
        guard let order = currentOrder else { return nil }
        return order.getOrderId()
    }
    
    func invalidateOrder() {
        currentOrder = nil
        endTimer()
    }
}


// MARK: - Private methods

extension OrderObserver {
    private func updateElapsedTimer() {
        elapsedTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTime),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc private func updateTime() {
        guard let order = currentOrder else {
            invalidateOrder()
            return
        }
        
        let elapsedTime = order.elapsedTime()
        guard elapsedTime != 0 else {
            delegate?.updateExpired(seconds: 0)
            expiredOrderOutputChannel?.send(nil)
            invalidateOrder()
            return
        }
        
        delegate?.updateExpired(seconds: elapsedTime)
    }
    
    private func endTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = nil
    }
}
