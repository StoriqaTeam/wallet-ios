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
    @IBOutlet private var toTitle: UILabel!
    @IBOutlet private var amountTitle: UILabel!
    @IBOutlet private var fromLabel: UILabel!
    @IBOutlet private var toLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var confirmButton: DefaultButton!
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
    
    func setupInitialState(fromAccount: String, toAccount: String, amount: String) {
        fromLabel.text = fromAccount
        toLabel.text = toAccount
        amountLabel.text = amount
    }

}


// MARK: - Private methods

extension ExchangeConfirmPopUpViewController {
    
    private func configureInterface() {
        titleLabel.font = Theme.Font.PopUp.title
        fromTitle.font = Theme.Font.PopUp.subtitle
        toTitle.font = Theme.Font.PopUp.subtitle
        amountTitle.font = Theme.Font.PopUp.subtitle
        fromLabel.font = Theme.Font.PopUp.text
        toLabel.font = Theme.Font.PopUp.text
        amountLabel.font = Theme.Font.PopUp.text
        
        titleLabel.textColor = Theme.Color.Text.main
        fromTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        toTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        amountTitle.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        fromLabel.textColor = Theme.Color.Text.main
        toLabel.textColor = Theme.Color.Text.main
        amountLabel.textColor = Theme.Color.Text.main
        
        closeButton.setTitleColor(Theme.Color.Text.main, for: .normal)
    }
    
    private func localizeText() {
        titleLabel.text = LocalizedStrings.screenTitle
        fromTitle.text = LocalizedStrings.fromTitle
        toTitle.text = LocalizedStrings.toTitle
        amountTitle.text = LocalizedStrings.amountTitle
        confirmButton.setTitle(LocalizedStrings.confirmButton, for: .normal)
        closeButton.setTitle(LocalizedStrings.closeButton, for: .normal)
    }
}
