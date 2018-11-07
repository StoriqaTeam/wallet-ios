//
//  SettingsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SettingsRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - SettingsRouterInput

extension SettingsRouter: SettingsRouterInput {
    func showProfile(from viewController: UIViewController) {
        ProfileModule.create(app: app).present(from: viewController)
    }
    
    func showChangePhone(from viewController: UIViewController) {
        ConnectPhoneModule.create(app: app).present(from: viewController)
    }
    
    func showSessions(from viewController: UIViewController) {
        SessionsModule.create(app: app).present(from: viewController)
    }
    
    func showChangePassword(from viewController: UIViewController) {
        ChangePasswordModule.create(app: app).present(from: viewController)
    }
}
