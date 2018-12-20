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
    
    var displayableName: String {
        switch self {
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
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
    func socialNetworkAuthSucceed(provider: SocialNetworkTokenProvider, token: String, email: String)
    func socialNetworkAuthFailed(provider: SocialNetworkTokenProvider)
}

class SocialNetworkAuthView: LoadableFromXib {
    typealias LocalizedStrings = Strings.SocialNetworkAuth
    
    private weak var viewModel: SocialNetworkAuthViewModel!
    
    enum SocialNetworkAuthViewType {
        case login
        case register
    }
    
    // IBOutlet
    @IBOutlet private var orLabel: UILabel!
    @IBOutlet private var facebookButton: UIButton!
    @IBOutlet private var googleButton: UIButton!
    @IBOutlet private var facebookTitle: UILabel!
    @IBOutlet private var googleTitle: UILabel!
    @IBOutlet private var separators: [UIView]!
    
    // Properties
    private var contentView: UIView?
    private weak var delegate: SocialNetworkAuthViewDelegate?
    private var formType: SocialNetworkAuthViewType = .login
    private weak var fromViewController: UIViewController!
    
    // IBActions
    
    @IBAction func facebookButtonTapHandler(_ sender: UIButton) {
        viewModel.signInWithFacebook(from: fromViewController)
    }
    
    @IBAction func googleButtonTapHandler(_ sender: UIButton) {
        viewModel.signWithGoogle()
    }
    
    func bindViewModel(_ viewModel: SocialNetworkAuthViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.viewModel.setUIGoogleDelegate(view: self)
    }
    
    func setUp(from viewController: UIViewController, delegate: SocialNetworkAuthViewDelegate, type: SocialNetworkAuthViewType) {
        self.delegate = delegate
        self.fromViewController = viewController
        self.formType = type
        
        configureInterface()
    }
}


// MARK: - SocialNetworkAuthViewModelProtocol

extension SocialNetworkAuthView: SocialNetworkAuthViewModelProtocol {
    func signInWithResult(_ result: Result<(token: String, email: String)>, provider: SocialNetworkTokenProvider) {
        switch result {
        case .failure(let error):
            delegate?.socialNetworkAuthFailed(provider: provider)
            log.warn(error.localizedDescription)
        case .success(let token):
            delegate?.socialNetworkAuthSucceed(provider: provider, token: token.token, email: token.email)
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
    private func configureInterface() {
        let buttonTitlePrefix: String = {
            switch formType {
            case .login: return LocalizedStrings.signInTitle
            case .register: return LocalizedStrings.signUpTitle
            }
        }()
        
        backgroundColor = .clear
        facebookTitle.text = buttonTitlePrefix + SocialNetworkTokenProvider.facebook.displayableName
        googleTitle.text = buttonTitlePrefix + SocialNetworkTokenProvider.google.displayableName
        orLabel.text = LocalizedStrings.orLabel
        separators.forEach { $0.backgroundColor = Theme.Color.SocialAuthView.separators }
        facebookButton.roundCorners(radius: 4, borderWidth: 1, borderColor: Theme.Color.SocialAuthView.borders)
        googleButton.roundCorners(radius: 4, borderWidth: 1, borderColor: Theme.Color.SocialAuthView.borders)
        
        facebookTitle.font = Theme.Font.extraSmallButtonTitle
        googleTitle.font = Theme.Font.extraSmallButtonTitle
        orLabel.font = Theme.Font.smallButtonTitle
        
        facebookTitle.textColor = Theme.Color.SocialAuthView.text
        googleTitle.textColor = Theme.Color.SocialAuthView.text
        orLabel.textColor = Theme.Color.SocialAuthView.text
    }
}
