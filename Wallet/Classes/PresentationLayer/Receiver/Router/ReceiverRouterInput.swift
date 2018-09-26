//
//  ReceiverRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ReceiverRouterInput: class {
    func showScanner(sendProvider: SendProviderProtocol, from viewController: UIViewController)
}
