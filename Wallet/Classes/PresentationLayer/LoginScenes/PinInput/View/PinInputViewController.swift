//
//  PinInputPasswordInputViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinInputViewController: UIViewController {
    
    typealias LocalizedString = Strings.PinInput

    var output: PinInputViewOutput!
    
    // MARK: IBOutlet
    
    @IBOutlet private var greetingContainerView: UIView!
    @IBOutlet private var greetingVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var greetingLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var userPhotoImageView: UIImageView?
    @IBOutlet private var userPhotoContainerView: ActivityIndicatorView?
    @IBOutlet private var pinContainerView: PinContainerView!
    @IBOutlet private var forgotPinButton: BaseButton!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.pinContainer(pinContainerView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewDidAppear()
    }
    
    
    // MARK: Life cycle
    
    @IBAction func iForgotPinPressed(_ sender: UIButton) {
        output.iForgotPinPressed()
    }

}


// MARK: - PinInputViewInput

extension PinInputViewController: PinInputViewInput {
    
    func setupInitialState(userPhoto: UIImage, userName: String) {
        configureUserPhoto(photo: userPhoto)
        configureGreeting(name: userName)
        configureInterface()
    }
    
    func inputSucceed() {
        showActivityIndicator()
        pinContainerView.completeInput()
    }
    
    func inputFailed() {
        pinContainerView.wrongPassword()
    }
    
    func clearInput() {
        pinContainerView.clearInput()
    }

}

// MARK: - Private methods

extension PinInputViewController {
    
    private func configureInterface() {
        view.backgroundColor = Theme.Color.backgroundColor
        subtitleLabel.text = LocalizedString.subtitle
        greetingLabel.font = Theme.Font.title
        subtitleLabel.font = Theme.Font.subtitle
        greetingLabel.textColor = Theme.Color.Text.main
        subtitleLabel.textColor = Theme.Color.Text.main.withAlphaComponent(0.5)
    }
    
    private func configureGreeting(name: String) {
        let greeting = LocalizedString.greetingLabelTitle
        greetingLabel.text = greeting + name + "!"
    }
    
    private func configureUserPhoto(photo: UIImage) {
        guard let userPhotoImageView = userPhotoImageView else { return }
        
        userPhotoImageView.image = photo
        userPhotoImageView.roundCorners(radius: userPhotoImageView.frame.height / 2)
        userPhotoImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    private func showActivityIndicator() {
        userPhotoContainerView?.showActivityIndicator(linewidth: 2.0)
    }
    
    private func hideActivityIndicator() {
        userPhotoContainerView?.hideActivityIndicator()
    }
}
