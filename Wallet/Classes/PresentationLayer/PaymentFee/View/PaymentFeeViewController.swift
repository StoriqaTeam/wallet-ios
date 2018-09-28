//
//  PaymentFeeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

struct PaymentFeeScreenData {
    let header: SendingHeaderData
    let address: String
    let receiverName: String
    let paymentFeeValuesCount: Int
}


class PaymentFeeViewController: UIViewController {

    var output: PaymentFeeViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var senderView: SendingHeaderView!
    @IBOutlet private var addressTitleLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var receiverTitleLabel: UILabel!
    @IBOutlet private var receiverLabel: UILabel!
    @IBOutlet private var paymentFeeTitleLabel: UILabel!
    @IBOutlet private var paymentFeeLabel: UILabel!
    @IBOutlet private var paymentFeeSlider: UISlider!
    @IBOutlet private var paymentFeeLowLabel: UILabel!
    @IBOutlet private var paymentFeeMediumLabel: UILabel!
    @IBOutlet private var paymentFeeHighLabel: UILabel!
    @IBOutlet private var medianWaitTitleLabel: UILabel!
    @IBOutlet private var medianWaitLabel: UILabel!
    @IBOutlet private var subtotalTitleLabel: UILabel!
    @IBOutlet private var subtotalLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var sendButton: DefaultButton!
    @IBOutlet private var scrollView: UIScrollView!
    
    // MARK: Variables
    
    private var paymentFeeValuesCount: Int! {
        didSet {
            if paymentFeeValuesCount > 1 {
                stepLength = 1.0 / Float(paymentFeeValuesCount - 1)
            } else {
                stepLength = 1
            }
        }
    }
    private var stepLength: Float = 1
    private var currentSliderStep = 0 {
        didSet {
            if oldValue != currentSliderStep {
                updateSelectedFee()
            }
        }
    }
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configInterface()
        output.viewIsReady()
    }
    
    // MARK: IBActions
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        let step = Int(round(sender.value / stepLength))
        sender.setValue(Float(step) * stepLength, animated: false)
        currentSliderStep = step
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        output.sendButtonPressed()
    }
}


// MARK: - PaymentFeeViewInput

extension PaymentFeeViewController: PaymentFeeViewInput {
    
    func setSubtotal(_ subtotal: String) {
        subtotalLabel.text = subtotal
    }
    
    func setMedianWait(_ wait: String) {
        medianWaitLabel.text = wait
    }
    
    func setPaymentFee(_ fee: String) {
        paymentFeeLabel.text = fee
    }
    
    func setupInitialState(apperance: PaymentFeeScreenData) {
        senderView.setup(apperance: apperance.header) { [weak self] in
            self?.output.editButtonPressed()
        }
        addressLabel.text = apperance.address
        receiverLabel.text = apperance.receiverName
        paymentFeeValuesCount = apperance.paymentFeeValuesCount
        
        paymentFeeSlider.setValue(0, animated: false)
        updateSelectedFee()
    }
    
    func setErrorHidden(_ hidden: Bool) {
        
        if hidden {
            sendButton.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 0
                self.sendButton.alpha = 1
            }) { (finished) in
                self.errorLabel.isHidden = true
            }
        } else {
            self.errorLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 1
                self.sendButton.alpha = 0
            }) { (finished) in
                self.sendButton.isHidden = true
            }
            
            scrollToBottom()
        }
        
    }
    
}

// MARK: - Private methods

extension PaymentFeeViewController {
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func updateSelectedFee() {
        output.newFeeSelected(currentSliderStep)
    }
    
    private func configInterface() {
        //TODO: локализации
        
        title = "Payment Fee"
        addressTitleLabel.font = UIFont.caption
        receiverTitleLabel.font = UIFont.caption
        paymentFeeTitleLabel.font = UIFont.caption
        medianWaitTitleLabel.font = UIFont.caption
        subtotalTitleLabel.font = UIFont.caption
        
        paymentFeeLowLabel.font = UIFont.smallText
        paymentFeeMediumLabel.font = UIFont.smallText
        paymentFeeHighLabel.font = UIFont.smallText
        errorLabel.font = UIFont.smallText
        
        addressTitleLabel.textColor = UIColor.bluegrey
        receiverTitleLabel.textColor = UIColor.bluegrey
        paymentFeeTitleLabel.textColor = UIColor.bluegrey
        medianWaitTitleLabel.textColor = UIColor.bluegrey
        subtotalTitleLabel.textColor = UIColor.bluegrey
        
        paymentFeeLowLabel.textColor = UIColor.captionGrey
        paymentFeeMediumLabel.textColor = UIColor.captionGrey
        paymentFeeHighLabel.textColor = UIColor.captionGrey
        
        errorLabel.textColor = UIColor.errorRed
        
        errorLabel.isHidden = true
        sendButton.isHidden = false
    }
    
}
