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
        configureNavBar()
        configInterface()
        output.contactsTableView(contactsTableView)
        addHideKeyboardGuesture()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        output.willMoveToParentVC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: Notification.Name.UITextFieldTextDidChange,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configInterface() {
        title = "receiver".localized()
        
        sendToTitleLabel.text = "send_to".localized()
        inputTextField.placeholder = "receiver_input_placeholder".localized()
        inputTextField.autocorrectionType = .no
        scanQRButton.setTitle("scan_QR".localized() + "   ", for: .normal)
        nextButton.setTitle("next".localized(), for: .normal)
    }
    
    // MARK: Actions
    
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
    
    func setupInitialState(apperance: SendingHeaderData) {
        senderView.setup(apperance: apperance, editBlock: { [weak self] in
            self?.output.editButtonPressed()
        })
    }
}


// MARK: - Private methods

extension ReceiverViewController {
    
    private func configureNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        setDarkTextNavigationBar()
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        output.inputDidChange(inputTextField.text ?? "")
    }
    
}
