//
//  SendConfirmPopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendConfirmPopUpViewController: UIViewController {

    var output: SendConfirmPopUpViewOutput!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var addressTitle: UILabel!
    @IBOutlet private var amountTitle: UILabel!
    @IBOutlet private var feeTitle: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var feeLabel: UILabel!
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
        containerView.roundCorners(radius: 7)
        titleLabel.font = Theme.Font.title

        addressTitle.font = Theme.Font.smallText
        amountTitle.font = Theme.Font.smallText
        feeTitle.font = Theme.Font.smallText
        addressLabel.font = Theme.Font.smallText
        amountLabel.font = Theme.Font.smallText
        feeLabel.font = Theme.Font.smallText
        
        addressTitle.textColor = Theme.Text.Color.lightGrey
        amountTitle.textColor = Theme.Text.Color.lightGrey
        feeTitle.textColor = Theme.Text.Color.lightGrey
        addressLabel.textColor = Theme.Text.Color.blackMain
        amountLabel.textColor = Theme.Text.Color.blackMain
        feeLabel.textColor = Theme.Text.Color.blackMain
        
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
