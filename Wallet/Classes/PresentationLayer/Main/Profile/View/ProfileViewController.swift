//
//  ProfileViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {

    var output: ProfileViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var gradientView: UIView!
    @IBOutlet private var photoContainer: UIView!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var stackViewContainer: UIView!
    @IBOutlet private var emailTitleLabel: UIView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var phoneTitleLabel: UILabel!
    @IBOutlet private var phoneLabel: UILabel!
    @IBOutlet private var connectPhoneButton: DefaultButton!
    @IBOutlet private var signOutButton: LightButton!
    @IBOutlet private var changePhoneButton: UIButton!
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.accountsHeaderGradientView()
        stackViewContainer.roundCorners([.topLeft, .topRight], radius: 24)
        roundPhotoContainerViews()
    }
    
    // MARK: IBActions

    @IBAction func settingsButtonTapped(_ sender: UIBarButtonItem) {
        output.settingsButtonTapped()
    }
    
    @IBAction func connectPhoneButtonTapped(_ sender: UIButton) {
        output.connectPhoneButtonTapped()
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        output.signOutButtonTapped()
    }
    
    @IBAction func changePhoneButtonTapped(_ sender: UIButton) {
        output.changePhoneButtonTapped()
    }
    
    @IBAction func photoTapped(_ sender: UIButton) {
        output.photoTapped()
    }
}


// MARK: - ProfileViewInput

extension ProfileViewController: ProfileViewInput {
    
    func setupInitialState(photo: UIImage,
                           name: String,
                           email: String,
                           hasPhone: Bool,
                           phone: String?) {
        photoImageView.image = photo
        nameLabel.text = name
        emailLabel.text = email
        
        if hasPhone {
            phoneLabel.text = phone
            phoneLabel.isHidden = false
            changePhoneButton.isHidden = false
            connectPhoneButton.isHidden = true
        } else {
            phoneLabel.text = nil
            phoneLabel.isHidden = true
            changePhoneButton.isHidden = true
            connectPhoneButton.isHidden = false
        }
        
        configureInterface()
        
    }
    
    func setPhoto(_ photo: UIImage) {
        photoImageView.image = photo
    }
    
}


// MARK: - Private methods

extension ProfileViewController {
    
    func configureInterface() {
        signOutButton.setup(color: UIColor.errorRed, borderAlpha: 0.1)
        
    }
    
    func roundPhotoContainerViews() {
        photoContainer.subviews.forEach { (roundView) in
            let height = roundView.frame.height
            roundView.roundCorners(radius: height / 2)
        }
    }
    
}