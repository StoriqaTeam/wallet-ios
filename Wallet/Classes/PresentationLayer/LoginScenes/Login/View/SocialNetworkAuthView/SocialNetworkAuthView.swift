//
//  SocialNetworkAuthView.swift
//  Wallet
//
//  Created by Storiqa on 24.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin

enum SocialNetworkTokenProvider {
    case google
    case facebook
    
    var name: String {
        switch self {
        case .google:
            return "GOOGLE"
        case .facebook:
            return "FACEBOOK"
        }
    }
}

protocol SocialNetworkAuthViewDelegate: class {
    func socialNetworkAuthViewDidTapFooterButton()
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String)
    func socialNetworkAuthFailed()
}

class SocialNetworkAuthView: UIView {
    var viewModel: SocialNetworkAuthViewModel!
    typealias Localized = Strings.SocialNetworkAuth
    
    enum SocialNetworkAuthViewType {
        case login
        case register
    }

    // IBOutlet
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var facebookButton: UIButton!
    @IBOutlet private var googleButton: UIButton!
    @IBOutlet private var footerTitleLabel: UILabel!
    @IBOutlet private var footerButton: UIButton!
    
    // Properties
    private var contentView: UIView?
    private weak var delegate: SocialNetworkAuthViewDelegate?
    private var formType: SocialNetworkAuthViewType = .login
    private var fromViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    // IBActions
    @IBAction func footerButtonTapHandler(_ sender: UIButton) {
        guard let delegate = delegate else { fatalError("delegate is nil") }
        delegate.socialNetworkAuthViewDidTapFooterButton()
    }
    
    @IBAction func facebookButtonTapHandler(_ sender: UIButton) {
        viewModel.signInWithFacebook(from: fromViewController)
    }
    
    func bindViewModel(_ viewModel: SocialNetworkAuthViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.viewModel.setUIGoogleDelegate(view: self)
    }
    
    @IBAction func googleButtonTapHandler(_ sender: UIButton) {
        viewModel.signWithGoogle()
    }
    
    func setUp(from viewController: UIViewController, delegate: SocialNetworkAuthViewDelegate, type: SocialNetworkAuthViewType) {
        self.delegate = delegate
        self.fromViewController = viewController
        self.formType = type

        switch type {
        case .login:
            titleLabel.text = Localized.sighInTitle
            footerTitleLabel.text = Localized.noAccountsTitle
            footerButton.setTitle(Localized.registerButtonTitle, for: .normal)
        case .register:
            titleLabel.text = Localized.sighUpTitle
            footerTitleLabel.text = Localized.haveAccountTitle
            footerButton.setTitle(Localized.signInButton, for: .normal)
        }
    }
}


// MARK: - SocialNetworkAuthViewModelProtocol

extension SocialNetworkAuthView: SocialNetworkAuthViewModelProtocol {
    func signInWithResult(_ result: Result<(provider: SocialNetworkTokenProvider, token: String)>) {
        switch result {
        case .failure(let error):
            delegate?.socialNetworkAuthFailed()
            log.warn(error.localizedDescription)
        case .success(let token):
            delegate?.socialNetworkAuthSucceed(provider: token.provider, token: token.token)
        }
    }
}


// MARK: - GIDSignInUIDelegate

extension SocialNetworkAuthView: GIDSignInUIDelegate {
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        log.debug("signInWillDispatch(signIn: GIDSignIn!, error: \(String(describing: error))")
        //TODO: signInWillDispatch(signIn: GIDSignIn!, error: NSError!)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        log.debug("signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)")
        //TODO: signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        log.debug("signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!)")
        //TODO: signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!)
    }
}

// MARK: - Private methods

extension SocialNetworkAuthView {
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SocialNetworkAuthView", bundle: bundle)
        guard let authView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Fail to load SocialNetworkAuthView")
        }
        
        authView.frame = bounds
        addSubview(authView)
        contentView = authView
    }
}
