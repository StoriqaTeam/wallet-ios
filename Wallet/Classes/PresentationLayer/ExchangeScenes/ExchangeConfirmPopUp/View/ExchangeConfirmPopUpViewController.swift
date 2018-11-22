//
//  ExchangeConfirmPopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeConfirmPopUpViewController: UIViewController {

    var output: ExchangeConfirmPopUpViewOutput!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var fromTitle: UILabel!
    @IBOutlet private var toTitle: UILabel!
    @IBOutlet private var amountTitle: UILabel!
    @IBOutlet private var fromLabel: UILabel!
    @IBOutlet private var toLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var confirmButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton!
    @IBOutlet private var verticalCenterConstraint: NSLayoutConstraint!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight
        configureInterface()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        verticalCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        containerView.roundCorners(radius: 7)
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
    
    private func animateDismiss(completion: @escaping () -> Void) {
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: completion)
        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = .clear
        }, completion: nil)
    }
    
}
