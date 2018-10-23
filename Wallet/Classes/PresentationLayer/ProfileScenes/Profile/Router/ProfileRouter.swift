//
//  ProfileRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ProfileRouter {

}


// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {
    
    func signOutConfirmPopUp(popUpDelegate: PopUpSignOutVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSignOutVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func signOut() {
        LoginModule.create().present()
    }
    
    func showSettings(from viewController: UIViewController) {
        SettingsModule.create().present(from: viewController)
    }
    
    func showConnectPhone(from viewController: UIViewController) {
        ConnectPhoneModule.create().present(from: viewController)
    }
}
