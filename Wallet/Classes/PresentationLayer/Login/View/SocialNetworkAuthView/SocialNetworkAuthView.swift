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
    func socialNetworkAuthSucceed(token: String)
    func socialNetworkAuthFailed()
}

class SocialNetworkAuthView: UIView {
    var viewModel: SocialNetworkAuthViewModel!
    
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
    
    func bindViewModel(_ vm: SocialNetworkAuthViewModel) {
        viewModel = vm
        viewModel.delegate = self
        viewModel.setUIGoogleDelegate(view: self)
    }
    
    @IBAction func googleButtonTapHandler(_ sender: UIButton) {
        viewModel.signWithGoogle()
    }
    
    func setUp(from vc: UIViewController, delegate: SocialNetworkAuthViewDelegate, type: SocialNetworkAuthViewType) {
        self.delegate = delegate
        self.fromViewController = vc
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
    func signInWithResult(_ result: Result<String>) {
        switch result {
        case .failure(let error):
            print(error.localizedDescription)
        case .success(let token):
            delegate?.socialNetworkAuthSucceed(token: token)
        }
    }
}


// MARK: - GIDSignInUIDelegate

extension SocialNetworkAuthView: GIDSignInUIDelegate {
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("signInWillDispatch(signIn: GIDSignIn!, error: \(error)")
        //TODO: signInWillDispatch(signIn: GIDSignIn!, error: NSError!)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)")
        //TODO: signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!)")
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