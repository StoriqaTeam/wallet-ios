//
//  MedianWaitFormatter.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol MedianWaitFormatterProtocol {
    func stringValue(from wait: Int) -> String
}

class MedianWaitFormatter: MedianWaitFormatterProtocol {
    func stringValue(from wait: Int) -> String {
        let seconds = wait % 60
        let minutes = (wait - seconds) / 60
        var result = ""
        
        if minutes > 0 { result = "\(minutes)m" }
        if seconds > 0 { result += "\(seconds)s" }
        if result.isEmpty { result += "-" }
        
        return result
    }
}
