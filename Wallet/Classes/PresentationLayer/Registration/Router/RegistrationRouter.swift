//
//  RegistrationRegistrationRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RegistrationRouter {

}


// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {
    func showLogin() {
        LoginModule.create().present()
    }
}
