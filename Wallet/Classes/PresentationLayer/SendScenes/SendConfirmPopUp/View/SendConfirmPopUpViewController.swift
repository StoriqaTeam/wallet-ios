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
    @IBOutlet private var confirmButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton!
    @IBOutlet private var separatorView: UIView!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        localizeText()
        output.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        separatorView.gradientView(
            colors: [UIColor.white.cgColor, UIColor.clear.cgColor],
            frame: separatorView.frame,
            startPoint: CGPoint(x: 0.0, y: 0.0),
            endPoint: CGPoint(x: 0.0, y: 1.0))
        
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
    
    func setupInitialState(address: String, amount: String, fee: String) {
        addressLabel.text = address
        amountLabel.text = amount
        feeLabel.text = fee
    }

}


// MARK: - Private methods

extension SendConfirmPopUpViewController {
    private func configureInterface() {
        titleLabel.font = Theme.Font.title

        addressTitle.font = Theme.Font.smallText
        amountTitle.font = Theme.Font.smallText
        feeTitle.font = Theme.Font.smallText
        addressLabel.font = Theme.Font.smallText
        amountLabel.font = Theme.Font.smallText
        feeLabel.font = Theme.Font.smallText
        totalToSendTitle.font = Theme.Font.smallText
        
        addressTitle.textColor = Theme.Color.Text.lightGrey
        amountTitle.textColor = Theme.Color.Text.lightGrey
        feeTitle.textColor = Theme.Color.Text.lightGrey
        addressLabel.textColor = Theme.Color.Text.blackMain
        amountLabel.textColor = Theme.Color.Text.blackMain
        feeLabel.textColor = Theme.Color.Text.blackMain
        totalToSendTitle.textColor = Theme.Color.Text.blackMain
        
        closeButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
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
