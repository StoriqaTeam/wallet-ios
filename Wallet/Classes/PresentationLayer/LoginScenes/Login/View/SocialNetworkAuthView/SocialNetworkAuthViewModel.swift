//
//  SocialNetworkAuthViewModel.swift
//  Wallet
//
//  Created by Storiqa on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit


protocol SocialNetworkAuthViewModelProtocol: class {
    func signInWithResult(_ result: Result<(token: String, email: String)>,
                          provider: SocialNetworkTokenProvider)
}


class SocialNetworkAuthViewModel: NSObject {
    typealias Token = (token: String, email: String)
    
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
        facebookLoginManager.loginBehavior = LoginBehavior.web
        facebookLoginManager.logOut()
        
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
                    self?.delegate.signInWithResult(result, provider: .facebook)
                case .cancelled:
                    log.debug("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    log.debug("Logged in!")
                    log.debug("grantedPermissions: \(grantedPermissions)")
                    log.debug("declinedPermissions: \(declinedPermissions)")
                    log.debug("accessToken: \(accessToken)")
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])
                    request?.start(completionHandler: { (_, result, error) in
                        
                        if let error = error {
                            let result: Result<Token> = .failure(error)
                            self?.delegate.signInWithResult(result, provider: .facebook)
                            return
                        }
                        
                        guard let userInfo = result as? [String: String],
                            let email = userInfo["email"] else {
                            let error = SocialNetworkViewModelError.emptyUserEmail
                            let result: Result<Token> = .failure(error)
                            self?.delegate.signInWithResult(result, provider: .facebook)
                            return
                        }
                        
                        let result: Result<Token> = .success((accessToken.authenticationToken, email: email))
                        self?.delegate.signInWithResult(result, provider: .facebook)
                    })
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
            
            guard let userEmail = user.profile.email else {
                let error = SocialNetworkViewModelError.emptyUserEmail
                result = .failure(error)
                delegate.signInWithResult(result, provider: .google)
                return
            }
            
            result = .success((token, userEmail))
        } else {
            log.debug("Falied signIn with google account: user token empty")
            let err = SocialNetworkViewModelError.userTokenIsEmpty
            result = .failure(err)
        }
        
        delegate.signInWithResult(result, provider: .google)
    }
}


enum SocialNetworkViewModelError: LocalizedError {
    case failToSign(error: Error)
    case userTokenIsEmpty
    case emptyUserEmail
    
    var localizedDescription: String {
        switch self {
        case .failToSign(let error):
            return "Failed signIn with account \(error.localizedDescription)"
        case .userTokenIsEmpty:
            return "Failed signIn with account: user token empty"
        case .emptyUserEmail:
            return "Failed signIn with account: user email empty"
        }
    }
}
