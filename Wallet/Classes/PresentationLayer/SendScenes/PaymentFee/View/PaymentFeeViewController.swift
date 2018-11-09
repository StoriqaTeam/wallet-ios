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
    @IBOutlet private var paymentFeeSlider: StepSlider!
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
        
        // FIXME: hidden before release
        
        paymentFeeSlider.superview!.isHidden = true
        medianWaitLabel.superview!.isHidden = true
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        output.willMoveToParentVC()
    }
    
    
    // MARK: IBActions
    
    @IBAction func sliderMoved(_ sender: StepSlider) {
        currentSliderStep = sender.currentSliderStep
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
        paymentFeeSlider.paymentFeeValuesCount = apperance.paymentFeeValuesCount
        
        paymentFeeSlider.setValue(0, animated: false)
        updateSelectedFee()
    }
    
    func setErrorHidden(_ hidden: Bool) {
        
        if hidden {
            sendButton.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 0
                self.sendButton.alpha = 1
            }, completion: { _ in
                self.errorLabel.isHidden = true
            })
        } else {
            self.errorLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 1
                self.sendButton.alpha = 0
            }, completion: { _ in
                self.sendButton.isHidden = true
            })
            
            scrollToBottom()
        }
        
    }
    
}

// MARK: - Private methods

extension PaymentFeeViewController {
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0,
                                   y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
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
        addressTitleLabel.font = Theme.Font.caption
        receiverTitleLabel.font = Theme.Font.caption
        paymentFeeTitleLabel.font = Theme.Font.caption
        medianWaitTitleLabel.font = Theme.Font.caption
        subtotalTitleLabel.font = Theme.Font.caption
        
        paymentFeeLowLabel.font = Theme.Font.smallText
        paymentFeeMediumLabel.font = Theme.Font.smallText
        paymentFeeHighLabel.font = Theme.Font.smallText
        errorLabel.font = Theme.Font.smallText
        
        addressTitleLabel.textColor = Theme.Color.bluegrey
        receiverTitleLabel.textColor = Theme.Color.bluegrey
        paymentFeeTitleLabel.textColor = Theme.Color.bluegrey
        medianWaitTitleLabel.textColor = Theme.Color.bluegrey
        subtotalTitleLabel.textColor = Theme.Color.bluegrey
        
        paymentFeeLowLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeMediumLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeHighLabel.textColor = Theme.Text.Color.captionGrey
        
        errorLabel.textColor = Theme.Text.Color.errorRed
  
        errorLabel.isHidden = true
        sendButton.isHidden = false
    }
}
