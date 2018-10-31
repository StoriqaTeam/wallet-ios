//
//  ShortPollingTimer.swift
//  Wallet
//
//  Created by Storiqa on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ShortPollingTimerProtocol {
    func startPolling()
    func invalidate()
    func pause()
    func resume()
    func setOutputChannel(_ channel: ShortPollingChannel)
}

class ShortPollingTimer: ShortPollingTimerProtocol {
    
    private var timer: DispatchSourceTimer?
    private let pollingQueue = DispatchQueue(label: "com.storiqaWallet.shortPolling", attributes: .concurrent)
    private let timeout: Int
    private var shortPollingChannelOutput: ShortPollingChannel?
    
    init(timeout: Int) {
        self.timeout = timeout
        subscribeNotification()
    }
    
    deinit {
        self.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    func startPolling() {
        timer?.cancel()
        timer = Timer.createDispatchTimer(interval: .seconds(timeout),
                                          leeway: .seconds(0),
                                          queue: pollingQueue) { [weak self] in
                                            self?.sendPollingSignal()
        }
    }
    
    func pause() {
         timer?.suspend()
    }
    
    func resume() {
        guard let pollingTimer = timer else { return }
        if pollingTimer.isCancelled {
            pollingTimer.resume()
        }
    }
    
    func invalidate() {
        timer?.cancel()
        timer = nil
    }
    
    // MARK: - Channel
    
    func setOutputChannel(_ channel: ShortPollingChannel) {
        self.shortPollingChannelOutput = channel
    }
}


// MARK: Private methods

extension ShortPollingTimer {
    private func sendPollingSignal() {
        log.debug("Send polling signal in thread - \(Thread.current)")
        DispatchQueue.main.async {
            self.shortPollingChannelOutput?.send(nil)
        }
    }
    
    @objc
    private func appMovedToBackground() {
        pause()
        log.debug("Polling timer paused")
    }
    
    @objc
    private func appBecomeActive() {
        resume()
        log.debug("Polling timer resumed")
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

extension Timer {
    
    class func createDispatchTimer(interval: DispatchTimeInterval,
                                   leeway: DispatchTimeInterval,
                                   deadline: DispatchTime = DispatchTime.now(),
                                   queue: DispatchQueue,
                                   block: @escaping () -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0),
                                                   queue: queue)
        timer.schedule(deadline: deadline,
                       repeating: interval,
                       leeway: leeway)
        
        
        let workItem = DispatchWorkItem(block: block)
        timer.setEventHandler(handler: workItem)
        timer.resume()
        return timer
    }
}
