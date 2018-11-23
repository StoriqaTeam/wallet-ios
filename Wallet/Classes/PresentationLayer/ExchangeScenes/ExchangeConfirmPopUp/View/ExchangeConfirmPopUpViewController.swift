//
//  ExchangeConfirmPopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeConfirmPopUpViewController: BasePopUpViewController {

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
        titleLabel.font = Theme.Font.title
        
        fromTitle.font = Theme.Font.smallText
        toTitle.font = Theme.Font.smallText
        amountTitle.font = Theme.Font.smallText
        fromLabel.font = Theme.Font.smallText
        toLabel.font = Theme.Font.smallText
        amountLabel.font = Theme.Font.smallText
        
        fromTitle.textColor = Theme.Text.Color.lightGrey
        toTitle.textColor = Theme.Text.Color.lightGrey
        amountTitle.textColor = Theme.Text.Color.lightGrey
        fromLabel.textColor = Theme.Text.Color.blackMain
        toLabel.textColor = Theme.Text.Color.blackMain
        amountLabel.textColor = Theme.Text.Color.blackMain
        
        closeButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
    }
    
}
