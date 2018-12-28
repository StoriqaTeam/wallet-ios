//
//  SendConfirmPopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendConfirmPopUpViewController: BasePopUpViewController {
    
    typealias LocalizedStrings = Strings.SendConfirmPopUp

    var output: SendConfirmPopUpViewOutput!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var addressTitle: UILabel!
    @IBOutlet private var amountTitle: UILabel!
    @IBOutlet private var feeTitle: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var feeLabel: UILabel!
    @IBOutlet private var totalToSendTitle: UILabel!
    @IBOutlet private var totalToSendLabel: UILabel!
    @IBOutlet private var confirmButton: GradientButton!
    @IBOutlet private var closeButton: BaseButton!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        localizeText()
        output.viewIsReady()
    }
    
    // MARK: - Action
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        animateDismiss { [weak self] in
            self?.output.confirmButtonTapped()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        animateDismiss { }
    }

}


// MARK: - SendConfirmPopUpViewInput

extension SendConfirmPopUpViewController: SendConfirmPopUpViewInput {
    
    func setupInitialState(address: String, amount: String, fee: String, total: String) {
        addressLabel.text = address
        amountLabel.text = amount
        totalToSendLabel.text = total
        
        if fee.isEmpty {
            feeLabel.text = LocalizedStrings.freeFeeLabel
            feeLabel.textColor = Theme.Color.mainOrange
        } else {
            feeLabel.text = fee
        }
    }

}


// MARK: - Private methods

extension SendConfirmPopUpViewController {
    private func configureInterface() {
        titleLabel.font = Theme.Font.PopUp.title
        addressTitle.font = Theme.Font.PopUp.subtitle
        amountTitle.font = Theme.Font.PopUp.subtitle
        feeTitle.font = Theme.Font.PopUp.subtitle
        totalToSendTitle.font = Theme.Font.PopUp.subtitle
        addressLabel.font = Theme.Font.PopUp.text
        amountLabel.font = Theme.Font.PopUp.text
        feeLabel.font = Theme.Font.PopUp.text
        totalToSendLabel.font = Theme.Font.PopUp.bigText
        
        titleLabel.textColor = Theme.Color.Text.main
        addressTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        amountTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        feeTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        totalToSendTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        addressLabel.textColor = Theme.Color.Text.main
        amountLabel.textColor = Theme.Color.Text.main
        feeLabel.textColor = Theme.Color.Text.main
        totalToSendLabel.textColor = Theme.Color.Text.main
    }
    
    private func localizeText() {
        titleLabel.text = LocalizedStrings.screenTitle
        addressTitle.text = LocalizedStrings.addressTitle
        amountTitle.text = LocalizedStrings.amountTitle
        feeTitle.text = LocalizedStrings.feeTitle
        totalToSendTitle.text = LocalizedStrings.totalTitle
        confirmButton.setTitle(LocalizedStrings.confirmButton, for: .normal)
        closeButton.setTitle(LocalizedStrings.closeButton, for: .normal)
    }
}
