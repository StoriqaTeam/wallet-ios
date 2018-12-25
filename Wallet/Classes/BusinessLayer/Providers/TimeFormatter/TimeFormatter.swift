//
//  TimeFormatter.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TimeFormatterProtocol {
    func stringValue(from value: Int) -> String
}

class TimeFormatter: TimeFormatterProtocol {
    func stringValue(from value: Int) -> String {
        let seconds = value % 60
        let minutes = (value - seconds) / 60
        var result = ""
        
        if minutes > 0 { result = "\(minutes) min " }
        if seconds > 0 { result += "\(seconds) sec" }
        if result.isEmpty { result += "0 sec" }
        
        return result
    }
}
