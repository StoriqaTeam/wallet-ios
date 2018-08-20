//
//  ValidationFieldProtocol.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ValidationFieldProtocol: class {
    associatedtype ValueFormat
    
    var isValid: Bool { get }
    var value: ValueFormat? { get }
    var validationBlock: ((ValueFormat)->Bool)? { set get }
}
