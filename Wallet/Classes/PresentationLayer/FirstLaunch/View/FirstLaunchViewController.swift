//
//  FirstLaunchFirstLaunchViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class FirstLaunchViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.FirstLaunch
    
    var output: FirstLaunchViewOutput!
    
    @IBOutlet private var getStartedButton: GradientButton!
    @IBOutlet private var signInButton: ColoredFramelessButton!
    @IBOutlet private var tureLogo: UIImageView!
    @IBOutlet private var tureTitle: UIImageView!
    @IBOutlet private var tureSubtitle: UILabel!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        prepareForAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performAnimations()
    }
    
    @IBAction func getStartedPressed(_ sender: UIButton) {
        output.showRegistration()
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        output.showLogin()
    }
}


// MARK: - FirstLaunchViewInput

extension FirstLaunchViewController: FirstLaunchViewInput {
    
    func setupInitialState() {
        view.backgroundColor = Theme.Color.backgroundColor
        getStartedButton.setTitle(LocalizedStrings.getStartedButton, for: .normal)
        signInButton.setTitle(LocalizedStrings.signInButton, for: .normal)
    }
}


// MARK: - Animations

extension FirstLaunchViewController {
    
    private func prepareForAnimations() {
        getStartedButton.alpha = 0
        signInButton.alpha = 0
        tureLogo.alpha = 0
        tureTitle.alpha = 0
        tureSubtitle.alpha = 0
        getStartedButton.transform = CGAffineTransform(translationX: 0, y: 10)
        signInButton.transform = CGAffineTransform(translationX: 0, y: 10)
    }
    
    private func performAnimations() {
        let tureLogoAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeIn) {
            self.tureLogo.alpha = 1
            self.tureTitle.alpha = 1
        }
        let tureSubtitleAnimator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn) {
            self.tureSubtitle.alpha = 0.5
        }
        let getStartedButtonAnimator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn) {
            self.getStartedButton.alpha = 1
            self.getStartedButton.transform = CGAffineTransform.identity
        }
        let signInAnimator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn) {
            self.signInButton.alpha = 1
            self.signInButton.transform = CGAffineTransform.identity
        }
        
        tureLogoAnimator.addCompletion { _ in
            tureSubtitleAnimator.startAnimation(afterDelay: 1.2)
            getStartedButtonAnimator.startAnimation(afterDelay: 1.4)
            signInAnimator.startAnimation(afterDelay: 1.6)
        }
        tureLogoAnimator.startAnimation(afterDelay: 0.5)
    }
    
}
