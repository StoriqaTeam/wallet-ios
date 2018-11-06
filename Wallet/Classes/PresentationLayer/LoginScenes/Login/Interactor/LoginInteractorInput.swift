//
//  LoginLoginInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol LoginInteractorInput: class {
    func getSocialVM() -> SocialNetworkAuthViewModel
    func signIn(email: String, password: String)
    func signIn(tokenProvider: SocialNetworkTokenProvider, oauthToken: String)
    func viewIsReady()
    func retry()
}
