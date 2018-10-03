//
//  ExchangeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeViewController: UIViewController {

    var output: ExchangeViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var gradientView: UIView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var recepientAccountTitleLabel: UILabel!
    @IBOutlet private var recepientAccountLabel: UILabel!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var convertedAmountLabel: UILabel!
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
    @IBOutlet private var exchangeButton: DefaultButton!
    
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
        addHideKeyboardGuesture()
        output.accountsCollectionView(accountsCollectionView)
        output.viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.configureCollections()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGradientView()
    }
    
    // MARK: IBActions
    
    @IBAction private func textDidChange(_ sender: UITextField) {
        output.amountChanged(sender.text ?? "")
    }
    
    @IBAction private func sliderMoved(_ sender: StepSlider) {
        currentSliderStep = sender.currentSliderStep
    }
    
    @IBAction private func recepientAccountPressed(_ sender: UIButton) {
        output.recepientAccountPressed()
    }
}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    
    func setupInitialState(numberOfPages: Int, paymentFeeValuesCount: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
        
        paymentFeeSlider.paymentFeeValuesCount = paymentFeeValuesCount
        paymentFeeSlider.setValue(0, animated: false)
        updateSelectedFee()
    }
    
    func setSubtotal(_ subtotal: String) {
        subtotalLabel.text = subtotal
    }
    
    func setMedianWait(_ wait: String) {
        medianWaitLabel.text = wait
    }
    
    func setPaymentFee(_ fee: String) {
        paymentFeeLabel.text = fee
    }
    
    func setPaymentFee(count: Int, value: Int) {
        paymentFeeSlider.paymentFeeValuesCount = count
        paymentFeeSlider.updateCurrentValue(step: value)
        currentSliderStep = value
    }
    
    func setErrorHidden(_ hidden: Bool) {
        
        if hidden {
            exchangeButton.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 0
                self.exchangeButton.alpha = 1
            }) { (finished) in
                self.errorLabel.isHidden = true
            }
        } else {
            self.errorLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 1
                self.exchangeButton.alpha = 0
            }) { (finished) in
                self.exchangeButton.isHidden = true
            }
            
            scrollToBottom()
        }
        
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
        dismissKeyboard()
    }
    
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func setConvertedAmount(_ amount: String) {
        convertedAmountLabel.text = amount
    }
    
    func setRecepientAccount(_ recepient: String) {
        recepientAccountLabel.text = recepient
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        exchangeButton.isHidden = !enabled
    }
}


// MARK: - UITextFieldDelegate

extension ExchangeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        output.amountDidBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        output.amountDidEndEditing()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            return output.isValidAmount(txtAfterUpdate)
        }
        
        return false
    }
    
}


// MARK: - UIScrollViewDelegate

extension ExchangeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavBarTransparency()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}


// MARK: - Private methods

extension ExchangeViewController {
    
    private func configureGradientView() {
        gradientView.accountsHeaderGradientView()
    }
    
    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func updateSelectedFee() {
        output.newFeeSelected(currentSliderStep)
    }
    
    private func setNavBarTransparency() {
        if let cellY = accountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
    
    private func configInterface() {
        scrollView.delegate = self
        amountTextField.delegate = self
        amountTextField.clearButtonMode = .never
        
        recepientAccountTitleLabel.font = UIFont.caption
        amountTitleLabel.font = UIFont.caption
        paymentFeeTitleLabel.font = UIFont.caption
        medianWaitTitleLabel.font = UIFont.caption
        subtotalTitleLabel.font = UIFont.caption
        
        paymentFeeLowLabel.font = UIFont.smallText
        paymentFeeMediumLabel.font = UIFont.smallText
        paymentFeeHighLabel.font = UIFont.smallText
        errorLabel.font = UIFont.smallText
        
        recepientAccountLabel.font = UIFont.generalText
        amountTextField.font = UIFont.generalText
        
        recepientAccountTitleLabel.textColor = UIColor.bluegrey
        amountTitleLabel.textColor = UIColor.bluegrey
        paymentFeeTitleLabel.textColor = UIColor.bluegrey
        medianWaitTitleLabel.textColor = UIColor.bluegrey
        subtotalTitleLabel.textColor = UIColor.bluegrey
        
        paymentFeeLowLabel.textColor = UIColor.captionGrey
        paymentFeeMediumLabel.textColor = UIColor.captionGrey
        paymentFeeHighLabel.textColor = UIColor.captionGrey
        
        
        errorLabel.textColor = UIColor.errorRed
        
        errorLabel.isHidden = true
        exchangeButton.isHidden = false
        
        //TODO: локализации
        amountTitleLabel.text = "amount".localized()
        amountTextField.placeholder = "enter_amount".localized()
    }
}
