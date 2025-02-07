//
//  PinInputPasswordInputInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PinInputInteractorOutput: class {
    func passwordIsCorrect()
    func passwordIsWrong()
    func touchAuthenticationSucceed()
    func touchAuthenticationFailed(error: String)
}
