//
//  RegistrationViewController.swift
//  Wallet
//
//  Created by user on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet var firstNameTextField: StqTextField!
    @IBOutlet var lastNameTextField: StqTextField!
    @IBOutlet var emailTextField: StqTextField!
    @IBOutlet var passwordTextField: StqTextField!
    @IBOutlet var agreementView: AgreementView!
    @IBOutlet var signUpButton: StqButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
        setDarkTextNavigationBar()
        addHideKeyboardGuesture()
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = firstNameTextField.validValue,
            let lastName = lastNameTextField.validValue,
            let email = emailTextField.validValue,
            let password = passwordTextField.validValue else {
                return
        }
        
        RegistrationProvider.shared.delegate = self
        RegistrationProvider.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}

extension RegistrationViewController: RegistrationProviderDelegate {
    func registrationProviderSucceed() {
        //TODO: registrationProviderSucceed
        self.showAlert(message: "succeed")

    }

    func registrationProviderFailedWithMessage(_ message: String) {
        self.showAlert(message: message)

    }

    func registrationProviderFailedWithErrors(_ errors: [ResponseError]) {
        //TODO: registrationProviderFailedWithErrors
        let desc = errors.map({ (error) -> String in
            if let error = error as? ResponseAPIError {
                return error.message?.description ?? ""
            } else if let error = error as? ResponseDefaultError {
                return error.details
            }
            return ""
        })

        self.showAlert(message: desc.description)

    }
}


//class RegistrationViewController: UIViewController {
//    private enum RegistrationCell: Int {
//        case firstName = 0
//        case lastName = 1
//        case email = 2
//        case password = 3
//        case agreement = 4
//        case button = 5
//    }
//
//    @IBOutlet private var tableView: UITableView?
//    private var validationFields = [RegistrationCell: ValidationFieldProtocol]()
//    private var cellsMargin: CGFloat = Constants.Sizes.isSmallScreen ? 16 : 40
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Registration"
//        setDarkTextNavigationBar()
//        addHideKeyboardGuesture()
//
//        tableView?.separatorStyle = .none
//        tableView?.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
//        tableView?.allowsSelection = false
//        tableView?.keyboardDismissMode = .onDrag
//
//        tableView?.register(UINib(nibName: "StqButtonCell", bundle: nil), forCellReuseIdentifier: "StqButtonCell")
//        tableView?.register(UINib(nibName: "StqTextFieldCell", bundle: nil), forCellReuseIdentifier: "StqTextFieldCell")
//        tableView?.register(UINib(nibName: "AgreementCell", bundle: nil), forCellReuseIdentifier: "AgreementCell")
//
//    }
//
//    func register() {
//        performSegue(withIdentifier: "SignUpSeque", sender: self)
//
//        for cell in validationFields {
//            if !cell.value.isValid {
//                //TODO: validateFields
//
//                return
//            }
//        }
//
//
//        guard let firstName = validationFields[.firstName]?.value as? String,
//            let lastName = validationFields[.lastName]?.value as? String,
//            let email = validationFields[.email]?.value as? String,
//            let password = validationFields[.password]?.value as? String else {
//                return
//        }
//
//        RegistrationProvider.shared.delegate = self
//        RegistrationProvider.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
//    }
//}
//
//extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.row {
//        case RegistrationCell.firstName.rawValue:
//            if let cell = textFieldCell(placeHolder: "First Name") {
//                validationFields[RegistrationCell.firstName] = cell.textField
//                return cell
//            }
//
//        case RegistrationCell.lastName.rawValue:
//            if let cell = textFieldCell(placeHolder: "Last Name") {
//                validationFields[RegistrationCell.lastName] = cell.textField
//                return cell
//            }
//
//        case RegistrationCell.email.rawValue:
//            if let cell = textFieldCell(placeHolder: "Email") {
//                validationFields[RegistrationCell.email] = cell.textField
//                return cell
//            }
//
//        case RegistrationCell.password.rawValue:
//            if let cell = textFieldCell(placeHolder: "Password") {
//                validationFields[RegistrationCell.password] = cell.textField
//                return cell
//            }
//
//        case RegistrationCell.agreement.rawValue:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "AgreementCell") as? AgreementCell {
//                cell.horisontalMargin.constant = cellsMargin
//                validationFields[RegistrationCell.agreement] = cell
//                return cell
//            }
//
//        case RegistrationCell.button.rawValue:
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "StqButtonCell") as? StqButtonCell {
//                cell.horisontalMargin.constant = cellsMargin
//                cell.button?.setTitle("SIGN UP", for: .normal)
//                cell.buttonTapHandlerBlock = {[weak self] in
//                    self?.register()
//                }
//                return cell
//            }
//
//        default:
//            break
//        }
//
//
//        return UITableViewCell()
//    }
//
//    private func textFieldCell(placeHolder: String) -> StqTextFieldCell? {
//        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "StqTextFieldCell") as? StqTextFieldCell else {
//            return nil
//        }
//
//        cell.horisontalMargin.constant = cellsMargin
//        cell.textField.placeholder = placeHolder
//        cell.textField.delegate = self
//        return cell
//    }
//}
//
//extension RegistrationViewController: StqTextFieldDelegate {
//    func textFieldShouldReturn(_ textField: StqTextField) -> Bool {
//        tableView?.endEditing(true)
//        return true
//    }
//}
//
//extension RegistrationViewController: RegistrationProviderDelegate {
//    func registrationProviderSucceed() {
//        //TODO: registrationProviderSucceed
//        self.showAlert(message: "succeed")
//
//    }
//
//    func registrationProviderFailedWithMessage(_ message: String) {
//        self.showAlert(message: message)
//
//    }
//
//    func registrationProviderFailedWithErrors(_ errors: [ResponseError]) {
//        //TODO: registrationProviderFailedWithErrors
//        let desc = errors.map({ (error) -> String in
//            if let error = error as? ResponseAPIError {
//                return error.message?.description ?? ""
//            } else if let error = error as? ResponseDefaultError {
//                return error.details
//            }
//            return ""
//        })
//
//        self.showAlert(message: desc.description)
//
//    }
//}


