//
//  HapticService.swift
//  Wallet
//
//  Created by Storiqa on 28/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol HapticServiceProtocol {
    func performNotificationHaptic(feedbackType: UINotificationFeedbackGenerator.FeedbackType)
    func performImpactHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle)
}

class HapticService: HapticServiceProtocol {
    
    func performNotificationHaptic(feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(feedbackType)
    }
    
    func performImpactHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
