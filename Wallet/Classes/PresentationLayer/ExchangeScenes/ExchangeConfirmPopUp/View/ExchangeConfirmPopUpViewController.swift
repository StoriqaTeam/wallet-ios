//
//  ExchangeConfirmPopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeConfirmPopUpViewController: BasePopUpViewController {
    
    typealias LocalizedStrings = Strings.ExchangeConfirmPopUp

    var output: ExchangeConfirmPopUpViewOutput!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var fromTitle: UILabel!
    @IBOutlet private var fromAccount: UILabel!
    @IBOutlet private var fromAmount: UILabel!
    @IBOutlet private var toTitle: UILabel!
    @IBOutlet private var toAccount: UILabel!
    @IBOutlet private var toAmount: UILabel!
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


// MARK: - ExchangeConfirmPopUpViewInput

extension ExchangeConfirmPopUpViewController: ExchangeConfirmPopUpViewInput {
    
    func setupInitialState(fromAccount: String, toAccount: String, fromAmount: String, toAmount: String) {
        self.fromAccount.text = fromAccount
        self.toAccount.text = toAccount
        self.fromAmount.text = fromAmount
        self.toAmount.text = toAmount
    }

}


// MARK: - Private methods

extension ExchangeConfirmPopUpViewController {
    
    private func configureInterface() {
        titleLabel.font = Theme.Font.PopUp.title
        fromTitle.font = Theme.Font.PopUp.subtitle
        toTitle.font = Theme.Font.PopUp.subtitle
        toAccount.font = Theme.Font.PopUp.subtitleMedium
        fromAccount.font = Theme.Font.PopUp.subtitleMedium
        toAmount.font = Theme.Font.PopUp.bigText
        fromAmount.font = Theme.Font.PopUp.bigText
        
        titleLabel.textColor = Theme.Color.Text.main
        fromTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        toTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        toAccount.textColor = Theme.Color.Text.main
        fromAccount.textColor = Theme.Color.Text.main
        toAmount.textColor = Theme.Color.Text.main
        fromAmount.textColor = Theme.Color.Text.main
    }
    
    private func localizeText() {
        titleLabel.text = LocalizedStrings.screenTitle
        fromTitle.text = LocalizedStrings.fromTitle
        toTitle.text = LocalizedStrings.toTitle
        confirmButton.setTitle(LocalizedStrings.confirmButton, for: .normal)
        closeButton.setTitle(LocalizedStrings.closeButton, for: .normal)
    }
}
