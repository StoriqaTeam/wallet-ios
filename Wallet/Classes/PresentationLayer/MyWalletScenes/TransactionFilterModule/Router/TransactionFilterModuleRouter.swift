//
//  TransactionFilterModuleRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionFilterRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - TransactionFilterModuleRouterInput

extension TransactionFilterRouter: TransactionFilterRouterInput {
    
}
