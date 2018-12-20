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
    
    @IBOutlet private var getStartedButton: LightButton!
    @IBOutlet private var signInButton: UIButton!
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        getStartedButton.setTitle(LocalizedStrings.getStartedButton, for: .normal)
        signInButton.setTitle(LocalizedStrings.signInButton, for: .normal)
        
        signInButton.titleLabel?.font = Theme.Font.buttonTitle
        getStartedButton.setTitleColor(Theme.Color.Button.enabledTitle, for: .normal)
        signInButton.setTitleColor(Theme.Color.Button.enabledBackground, for: .normal)
        tureSubtitle.font = Theme.Font.smallMediumWeightText
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
        // for fade only remove next line
        tureLogo.transform = CGAffineTransform(scaleX: 10, y: 10)
        getStartedButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        signInButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    private func performAnimations() {
        let tureLogoAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn) {
            self.tureLogo.alpha = 1
            self.tureLogo.transform = CGAffineTransform.identity
        }
        let tureTitleAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeIn) {
            self.tureTitle.alpha = 1
        }
        let tureSubtitleAnimator = UIViewPropertyAnimator(duration: 0.35, curve: .easeIn) {
            self.tureSubtitle.alpha = 0.5
        }
        let getStartedButtonAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.getStartedButton.alpha = 1
            self.getStartedButton.transform = CGAffineTransform.identity
        }
        let signInAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.signInButton.alpha = 1
            self.signInButton.transform = CGAffineTransform.identity
        }
        
        tureLogoAnimator.addCompletion { _ in tureTitleAnimator.startAnimation(afterDelay: 0.5) }
        tureTitleAnimator.addCompletion { _ in tureSubtitleAnimator.startAnimation(afterDelay: 0.3) }
        tureSubtitleAnimator.addCompletion { _ in getStartedButtonAnimator.startAnimation(afterDelay: 0.5) }
        getStartedButtonAnimator.addCompletion { _ in signInAnimator.startAnimation() }
        
        tureLogoAnimator.startAnimation()
    }
    
}
