//
//  EditProfileViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EditProfileViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.EditProfile

    var output: EditProfileViewOutput!

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var saveButton: UIButton!
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text else {
                fatalError("In this case form validation must be failed ")
        }
        
        output.saveButtonTapped(firstName: firstName, lastName: lastName)
    }

    @IBAction func textChanged(_ sender: UITextField) {
        output.valuesChanged(firstName: firstNameTextField.text,
                             lastName: lastNameTextField.text)
    }
    
}


// MARK: - EditProfileViewInput

extension EditProfileViewController: EditProfileViewInput {
    
    func setupInitialState(firstName: String, lastName: String) {
        configureInterface()
        addHideKeyboardGuesture()
        localizeText()
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
    }

    func setButtonEnabled(_ enabled: Bool) {
        saveButton.isEnabled = enabled
    }
    
}


// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        default:
            dismissKeyboard()
        }
        
        return true
    }
}


// MARK: - Private methods

extension EditProfileViewController {
    
    private func configureInterface() {
        titleLabel.font = Theme.Font.caption
        firstNameTextField.font = Theme.Font.generalText
        lastNameTextField.font = Theme.Font.generalText
        
        titleLabel.textColor = Theme.Color.Text.captionGrey
        firstNameTextField.textColor = Theme.Color.Text.blackMain
        lastNameTextField.textColor = Theme.Color.Text.blackMain
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    private func localizeText() {
        titleLabel.text = LocalizedStrings.personalInfoTitle
        firstNameTextField.text = LocalizedStrings.firstNamePlaceholder
        lastNameTextField.text = LocalizedStrings.lastNamePlaceholder
        saveButton.setTitle(LocalizedStrings.saveButton, for: .normal)
    }
    
}
