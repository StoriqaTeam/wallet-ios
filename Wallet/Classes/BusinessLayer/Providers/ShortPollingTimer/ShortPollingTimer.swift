//
//  ShortPollingTimer.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ShortPollingTimerProtocol {
    func startPolling()
    func invalidate()
    func pause()
    func resume()
}

class ShortPollingTimer: ShortPollingTimerProtocol {
    
    private var timer: DispatchSourceTimer?
    private let pollingQueue = DispatchQueue(label: "com.storiqaWallet.shortPolling", attributes: .concurrent)
    private let timeout: Int
    
    init(timeout: Int) {
        self.timeout = timeout
        startPolling()
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
                                          queue: pollingQueue) { [unowned self] in
                                            self.sendPollingSignal()
        }
    }
    
    func pause() {
         timer?.suspend()
    }
    
    func resume() {
        timer?.resume()
    }
    
    func invalidate() {
        timer?.cancel()
        timer = nil
    }
    
}


// MARK: Private methods

extension ShortPollingTimer {
    private func sendPollingSignal() {
        print("Хэндлер отработал в потоке - \(Thread.current)")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .startPolling, object: nil)
            log.info("Сигнал поллинга!!!!!!")
        }
    }
    
    @objc
    private func appMovedToBackground() {
        pause()
        log.info("Таймер паусед!!!!!!")
    }
    
    @objc
    private func appBecomeActive() {
        resume()
        log.info("Таймер ресюмед!!!!!!")
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


extension Notification.Name {
    public static let startPolling = Notification.Name("StartPolling")
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
