//
//  SocialNetworkAuthViewModel.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin


protocol SocialNetworkAuthViewModelProtocol: class {
    func signInWithResult(_ result: Result<(provider: SocialNetworkTokenProvider, token: String)>)
}


class SocialNetworkAuthViewModel: NSObject {
    typealias Token = (provider: SocialNetworkTokenProvider, token: String)
    
    weak var delegate: SocialNetworkAuthViewModelProtocol!
    
    private let facebookLoginManager: LoginManager
    private let gidSignIn: GIDSignIn
    
    init(facebookLoginManager: LoginManager) {
        self.gidSignIn = GIDSignIn.sharedInstance()
        self.facebookLoginManager = facebookLoginManager
    }
    
    func setUIGoogleDelegate(view: GIDSignInUIDelegate) {
        gidSignIn.delegate = self
        gidSignIn.uiDelegate = view
    }
    
    func signWithGoogle() {
        gidSignIn.signIn()
    }
    
    func signInWithFacebook(from viewController: UIViewController) {
        let viewController = UIViewController()
        facebookLoginManager.logIn(
            readPermissions: [.userGender, .publicProfile, .email],
            viewController: viewController,
            completion: { [weak self] logResult in
                switch logResult {
                case .failed(let error):
                    log.debug(error)
                    let err = SocialNetworkViewModelError.failToSign(error: error)
                    let result: Result<Token> = .failure(err)
                    self?.delegate.signInWithResult(result)
                case .cancelled:
                    log.debug("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    log.debug("Logged in!")
                    log.debug("grantedPermissions: \(grantedPermissions)")
                    log.debug("declinedPermissions: \(declinedPermissions)")
                    log.debug("accessToken: \(accessToken)")
                    let result: Result<Token> = .success((SocialNetworkTokenProvider.facebook, accessToken.authenticationToken))
                    self?.delegate.signInWithResult(result)
                }
            })
    }
}


// MARK: - GIDSignInDelegate

extension SocialNetworkAuthViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        let result: Result<Token>
        
        if let error = error {
            log.debug("Falied signIn with google account \(error.localizedDescription)")
            let err = SocialNetworkViewModelError.failToSign(error: error)
            result = .failure(err)
        } else if let token = user?.authentication?.accessToken {
            result = .success((SocialNetworkTokenProvider.google, token))
        } else {
            log.debug("Falied signIn with google account: user token empty")
            let err = SocialNetworkViewModelError.userTokenIsEmpty
            result = .failure(err)
        }
        
        delegate.signInWithResult(result)
    }
}


enum SocialNetworkViewModelError: LocalizedError {
    case failToSign(error: Error)
    case userTokenIsEmpty
    
    var localizedDescription: String {
        switch self {
        case .failToSign(let error):
            return "Failied signIn with account \(error.localizedDescription)"
        case .userTokenIsEmpty:
            return "Failed signIn with account: user token empty"
        }
    }
}
