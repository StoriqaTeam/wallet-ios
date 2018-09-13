//
//  SocialNetworkAuthView.swift
//  Wallet
//
//  Created by user on 24.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn

protocol SocialNetworkAuthViewDelegate: class {
    func socialNetworkAuthViewDidTapFooterButton()
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String)
    func socialNetworkAuthFailed()
}

class SocialNetworkAuthView: UIView {
    typealias FacebookLoginManager = LoginManager
    enum SocialNetworkAuthViewType {
        case login
        case register
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var facebookButton: UIButton!
    @IBOutlet private var googleButton: UIButton!
    @IBOutlet private var footerTitleLabel: UILabel!
    @IBOutlet private var footerButton: UIButton!
    
    private var contentView: UIView?
    private weak var delegate: (UIViewController & SocialNetworkAuthViewDelegate)?
    private var formType: SocialNetworkAuthViewType = .login
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SocialNetworkAuthView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Uncomment to automatically sign in the user.
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func setUp(delegate: (UIViewController & SocialNetworkAuthViewDelegate), type: SocialNetworkAuthViewType) {
        self.delegate = delegate
        self.formType = type
        
        switch type {
        case .login:
            titleLabel.text = "Sign in via social account"
            footerTitleLabel.text = "Haven’t got account?"
            footerButton.setTitle("Register", for: .normal)
        case .register:
            titleLabel.text = "Sign up via social account"
            footerTitleLabel.text = "Have an account?"
            footerButton.setTitle("Sign in", for: .normal)
        }
    }
    
    @IBAction func footerButtonTapHandler(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.socialNetworkAuthViewDidTapFooterButton()
        } else {
            log.warn("delegate is nil")
        }
    }
    
    @IBAction func facebookButtonTapHandler(_ sender: UIButton) {
        let loginManager = FacebookLoginManager()
        
        loginManager.logIn(readPermissions: [.userGender, .publicProfile, .email], viewController: delegate) { [weak self] loginResult in
            guard let strongSelf = self else {
                log.warn("self is nil")
                return
            }
            guard let delegate = strongSelf.delegate else {
                log.warn("delegate is nil")
                return
            }
            
            switch loginResult {
            case .failed(let error):
                log.debug(error)
                delegate.socialNetworkAuthFailed()
            case .cancelled:
                log.debug("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                log.debug("Logged in!")
                log.debug("grantedPermissions: \(grantedPermissions)")
                log.debug("declinedPermissions: \(declinedPermissions)")
                log.debug("accessToken: \(accessToken)")
                
                //TODO: get user email from facebook?
                delegate.socialNetworkAuthSucceed(provider: .facebook, token: accessToken.authenticationToken, email: "")
            }
        }
    }
    
    @IBAction func googleButtonTapHandler(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

extension SocialNetworkAuthView: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)")
        print(user.authentication.accessToken)
        if let error = error {
            log.debug("Falied signIn with google account \(error.localizedDescription)")
            delegate?.socialNetworkAuthFailed()
        } else if let token = user?.authentication?.accessToken {
            delegate?.socialNetworkAuthSucceed(provider: .google, token: token, email: user?.profile?.email ?? "")
        } else {
            log.debug("Falied signIn with google account: user token empty")
            delegate?.socialNetworkAuthFailed()
        }
    }
}

extension SocialNetworkAuthView: GIDSignInUIDelegate {
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("signInWillDispatch(signIn: GIDSignIn!, error: NSError!)")
        //TODO: signInWillDispatch(signIn: GIDSignIn!, error: NSError!)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)")
        //TODO: signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        print("signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!)")
        //TODO: signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!)
    }
}
