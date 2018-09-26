//
//  PaymentFeeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeeViewController: UIViewController {

    var output: PaymentFeeViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet var senderView: SendingHeaderView!
    @IBOutlet var addressTitleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var receiverTitleLabel: UILabel!
    @IBOutlet var receiverLabel: UILabel!
    @IBOutlet var paymentFeeTitleLabel: UILabel!
    @IBOutlet var paymentFeeLabel: UILabel!
    @IBOutlet var paymentFeeSlider: UISlider!
    @IBOutlet var paymentFeeLowLabel: UILabel!
    @IBOutlet var paymentFeeMediumLabel: UILabel!
    @IBOutlet var paymentFeeHighLabel: UILabel!
    @IBOutlet var medianWaitTitleLabel: UILabel!
    @IBOutlet var medianWaitLabel: UILabel!
    @IBOutlet var subtotalTitleLabel: UILabel!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var sendButton: DefaultButton!
    
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
        output.viewIsReady()
        configInterface()
    }
    
    private func configInterface() {
        //TODO: локализации
        
        title = "Payment Fee"
        addressTitleLabel.font = UIFont.caption
        receiverTitleLabel.font = UIFont.caption
        paymentFeeTitleLabel.font = UIFont.caption
        subtotalTitleLabel.font = UIFont.caption
        
        paymentFeeLowLabel.font = UIFont.smallText
        paymentFeeMediumLabel.font = UIFont.smallText
        paymentFeeHighLabel.font = UIFont.smallText
        
        
        paymentFeeSlider.setValue(0, animated: false)
    }
    
    // MARK: IBActions
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        let step = Int(round(sender.value / stepLength))
        sender.setValue(Float(step) * stepLength, animated: false)
        currentSliderStep = step
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
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
        
        updateSelectedFee()
    }
    
}


extension PaymentFeeViewController {
    
    private func updateSelectedFee() {
        output.newFeeSelected(currentSliderStep)
    }
    
}
