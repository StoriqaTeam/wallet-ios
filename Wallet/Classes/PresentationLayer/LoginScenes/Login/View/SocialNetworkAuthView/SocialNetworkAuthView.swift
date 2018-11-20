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
            return "google"
        case .facebook:
            return "facebook"
        }
    }

    init?(_ string: String) {
        switch string.lowercased() {
        case "google":
            self = .google
        case "facebook":
            self = .facebook
        default:
            return nil
        }
    }
}

protocol SocialNetworkAuthViewDelegate: class {
    func socialNetworkAuthViewDidTapFooterButton()
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String)
    func socialNetworkAuthFailed()
}

class SocialNetworkAuthView: LoadableFromXib {
    private weak var viewModel: SocialNetworkAuthViewModel!
    
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
    private weak var fromViewController: UIViewController!
    
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
            titleLabel.text = "sign_in_social".localized()
            footerTitleLabel.text = "have_no_account".localized()
            footerButton.setTitle("register".localized(), for: .normal)
        case .register:
            titleLabel.text = "sign_up_social".localized()
            footerTitleLabel.text = "have_account".localized()
            footerButton.setTitle("sign_in".localized(), for: .normal)
        }
    }
}


// MARK: - SocialNetworkAuthViewModelProtocol

extension SocialNetworkAuthView: SocialNetworkAuthViewModelProtocol {
    func signInWithResult(_ result: Result<(provider: SocialNetworkTokenProvider, token: String, email: String)>) {
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
