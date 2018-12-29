//
//  DepositShortPollingTimer.swift
//  Wallet
//
//  Created by Storiqa on 30/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol DepositShortPollingTimerProtocol {
    func startPolling()
    func pause()
    func resume()
    func setOutputChannel(_ channel: DepositShortPollingChannel)
}


class DepositShortPollingTimer: DepositShortPollingTimerProtocol {
    
    private enum State {
        case paused
        case resumed
    }
    
    private var state: State = .resumed
    
    private var timer: DispatchSourceTimer?
    private let pollingQueue = DispatchQueue(label: "com.storiqaWallet.depositShortPolling", attributes: .concurrent)
    private let timeout: Int
    private var shortPollingChannelOutput: DepositShortPollingChannel?
    
    
    init(timeout: Int) {
        self.timeout = timeout
        subscribeNotification()
    }
    
    deinit {
        timer?.cancel()
        resume()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    func startPolling() {
        timer?.cancel()
        resume()
        timer = Timer.createDispatchTimer(interval: .seconds(timeout),
                                          leeway: .seconds(0),
                                          queue: pollingQueue) { [weak self] in
                                            self?.sendPollingSignal()
        }
    }
    
    func pause() {
        if state == .paused {
            return
        }
        log.debug("Deposit Polling timer paused")
        
        state = .paused
        timer?.suspend()
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer?.resume()
        log.debug("Deposit Polling timer resumed")
    }
    
    func invalidate() {
        timer?.cancel()
        print("Timer state is \(state)")
        timer = nil
        log.debug("Deposit Polling timer invalidated")
    }
    
    // MARK: - Channel
    
    func setOutputChannel(_ channel: DepositShortPollingChannel) {
        self.shortPollingChannelOutput = channel
    }
    
}


// MARK: - Private methods

extension DepositShortPollingTimer {
    private func sendPollingSignal() {
        log.debug("Send Deposit polling signal in thread - \(Thread.current)")
        DispatchQueue.main.async {
            self.shortPollingChannelOutput?.send(nil)
        }
    }
    
    @objc
    private func appMovedToBackground() {
        pause()
    }
    
    @objc
    private func appBecomeActive() {
        resume()
    }
    
    private func subscribeNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
    }
}
