//
//  SendProvider.swift
//  Wallet
//
//  Created by Storiqa on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendProviderProtocol {
    
}

class SendProvider: SendProviderProtocol {
    var selectedAccount: Account?
    var receiverCurrency: Currency?
    var amount: String?
    var convertedAmount: String?
    var receiver: Contact?
    var receiverAddress: String?
    var paymentFee: String?
    
}
