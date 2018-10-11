//
//  ConnectPhoneViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import CoreTelephony


class ConnectPhoneViewController: UIViewController {

    var output: ConnectPhoneViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var headerTextLabel: UILabel!
    @IBOutlet private var phoneTextField: UITextField!
    @IBOutlet private var footerTextLabel: UILabel!
    @IBOutlet private var connectButton: DefaultButton!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    @IBAction func connectButtonPressed(_ sender: UIButton) {
        output.connectButtonPressed(phoneTextField.text!)
    }
}


// MARK: - ConnectPhoneViewInput

extension ConnectPhoneViewController: ConnectPhoneViewInput {
    
    func setupInitialState(phone: String, buttonTitle: String) {
        addHideKeyboardGuesture()
        configureInterface()
        
        phoneTextField.text = phone
        connectButton.setTitle(buttonTitle, for: .normal)
    }

    func setConnectButtonEnabled(_ enabled: Bool) {
        connectButton.isEnabled = enabled
    }
    
}


// MARK: - UITextFieldDelegate

extension ConnectPhoneViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            if txtAfterUpdate.trim().count == 1 && txtAfterUpdate != "+" {
                textField.text = "+" + txtAfterUpdate
                return false
            }
            
            return output.isValidPhoneNumber(txtAfterUpdate)
        }
        return true
    }
    
}


// MARK: - Private methods

extension ConnectPhoneViewController {
    
    private func configureInterface() {
        phoneTextField.delegate = self
        
        headerTextLabel.font = UIFont.smallText
        footerTextLabel.font = UIFont.smallText
        
        headerTextLabel.textColor = Theme.Color.captionGrey
        footerTextLabel.textColor = Theme.Color.captionGrey
        
        // TODO: localizations
    }
    
}
