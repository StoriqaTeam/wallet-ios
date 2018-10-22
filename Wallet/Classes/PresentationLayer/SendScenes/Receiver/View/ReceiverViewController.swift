//
//  ReceiverViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import AVFoundation


class ReceiverViewController: UIViewController {
    
    typealias Localization = Strings.Receiver
    
    var output: ReceiverViewOutput!
    
    // MARK: IBOutlets
    
    @IBOutlet private var senderView: SendingHeaderView!
    @IBOutlet private var sendToTitleLabel: UILabel!
    @IBOutlet private var scanQRButton: UIButton!
    @IBOutlet private var inputTextField: UnderlinedTextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var contactsTableView: UITableView!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInterface()
        output.contactsTableView(contactsTableView)
        addHideKeyboardGuesture()
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureInput()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    private func configInterface() {
        sendToTitleLabel.text = Localization.sendToInputTitle
        inputTextField.placeholder = Localization.sendToInputPlaceholder
        inputTextField.autocorrectionType = .no
        scanQRButton.setTitle(Localization.scanQRButton + "   ", for: .normal)
        nextButton.setTitle(Localization.nextButton, for: .normal)
    }
    
    // MARK: Actions
    
    @IBAction private func textDidChange(_ sender: UITextField) {
        output.inputDidChange(sender.text ?? "")
    }
    
    @IBAction private func scanButtonPressed() {
        output.scanButtonPressed()
    }
    
    @IBAction private func nextButtonPressed() {
        output.nextButtonPressed()
    }
}


// MARK: - ReceiverViewInput

extension ReceiverViewController: ReceiverViewInput {
    
    func setNextButtonHidden(_ hidden: Bool) {
        nextButton.isHidden = hidden
    }
    
    func setInput(_ input: String) {
        inputTextField.text = input
    }
    
    func setupInitialState(apperance: SendingHeaderData, canScan: Bool) {
        senderView.setup(apperance: apperance, editBlock: { [weak self] in
            self?.output.editButtonPressed()
        })
        
        if !canScan {
            scanQRButton.isHidden = true
        }
    }
}
