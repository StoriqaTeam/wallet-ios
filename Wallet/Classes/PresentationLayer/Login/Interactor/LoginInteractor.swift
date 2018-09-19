//
//  LoginLoginInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class LoginInteractor {
    weak var output: LoginInteractorOutput!
    
    private let socialViewVM: SocialNetworkAuthViewModel
    
    init(socialViewVM: SocialNetworkAuthViewModel) {
        self.socialViewVM = socialViewVM
    }
}


// MARK: - LoginInteractorInput

extension LoginInteractor: LoginInteractorInput {
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
}
