//
//  SendViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    
    
    typealias LocalizedStrings = Strings.Send
    
    var output: SendViewOutput!
    
    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var receiverTitleLabel: UILabel!
    @IBOutlet private var scanQRButton: UIButton!
    @IBOutlet private var receiverTextField: UnderlinedTextField!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var paymentFeeView: UIView!
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
    @IBOutlet private var loaderView: ActivityIndicatorView!
    
    
    // MARK: Variables
    
    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    private var currentSliderStep = 0
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.accountsCollectionView(accountsCollectionView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.configureCollections()
        output.viewWillAppear()
        setNavBarTransparency()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        output.configureCollections()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Actions
    
    @IBAction private func amountDidChange(_ sender: UITextField) {
        output.amountChanged(sender.text ?? "")
    }
    
    @IBAction func addressDidChange(_ sender: UITextField) {
        output.receiverAddressDidChange(sender.text ?? "")
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        output.sendButtonPressed()
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        output.scanButtonPressed()
    }
    
    @IBAction private func sliderMoved(_ sender: StepSlider) {
        let oldValue = currentSliderStep
        currentSliderStep = sender.currentSliderStep
        
        if oldValue != currentSliderStep {
            output.newFeeSelected(currentSliderStep)
        }
    }
}


// MARK: - SendViewInput

extension SendViewController: SendViewInput {
    
    func setupInitialState(numberOfPages: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
        
        addNotificationObservers()
        configInterface()
        addHideKeyboardGuesture()
        localizeText()
    }
    
    func setScannedAddress(_ address: String) {
        receiverTextField.text = address
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
    
    func setPaymentFee(count: Int, value: Int, enabled: Bool) {
        paymentFeeSlider.paymentFeeValuesCount = count
        paymentFeeSlider.updateCurrentValue(step: value)
        paymentFeeView.alpha = enabled ? 1 : 0.22
        paymentFeeView.isUserInteractionEnabled = enabled
        currentSliderStep = value
    }
    
    func setFeeUpdateIndicator(hidden: Bool) {
        loaderView.isHidden = hidden
        
        if hidden {
            loaderView.hideActivityIndicator()
        } else {
            loaderView.showActivityIndicator(linewidth: 2, color: Theme.Color.Text.captionGrey)
        }
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }
    
    func setAddressError(_ message: String?) {
        receiverTextField.errorText = message
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        sendButton.isEnabled = enabled
    }
    
    func setEnoughFundsErrorHidden(_ errorHidden: Bool) {
        if errorHidden {
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 0
            }, completion: { finished in
                if finished {
                    self.errorLabel.isHidden = true
                    self.errorLabel.text = ""
                    self.view.layoutSubviews()
                }
            })
            
        } else {
            self.errorLabel.isHidden = false
            self.errorLabel.text = LocalizedStrings.notEnoughFundsErrorMessage
            
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutSubviews()
                self.errorLabel.alpha = 1
            }, completion: { finished in
                if finished {
                    self.errorLabel.isHidden = false
                }
            })
        }
    }
}


// MARK: - UITextFieldDelegate

extension SendViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case receiverTextField:
            amountTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case amountTextField:
            output.amountDidBeginEditing()
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case amountTextField:
            output.amountDidEndEditing()
        case receiverTextField:
            output.receiverAddressDidChange(textField.text ?? "")
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard textField == amountTextField else {
            return true
        }
        
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            return output.isValidAmount(txtAfterUpdate)
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case receiverTextField:
            output.receiverAddressDidChange("")
        default:
            break
        }
        
        return true
    }
    
}


// MARK: - UIScrollViewDelegate

extension SendViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNavBarTransparency()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !isKeyboardAnimating {
            dismissKeyboard()
        }
    }
}


// MARK: - Private methods

extension SendViewController {
    
    private func configInterface() {
        amountTextField.delegate = self
        receiverTextField.delegate = self
        scrollView.delegate = self
        
        receiverTextField.autocorrectionType = .no
        
        receiverTitleLabel.font = Theme.Font.caption
        amountTitleLabel.font = Theme.Font.caption
        paymentFeeTitleLabel.font = Theme.Font.caption
        medianWaitTitleLabel.font = Theme.Font.caption
        subtotalTitleLabel.font = Theme.Font.caption
        paymentFeeLowLabel.font = Theme.Font.smallText
        paymentFeeMediumLabel.font = Theme.Font.smallText
        paymentFeeHighLabel.font = Theme.Font.smallText
        
        receiverTitleLabel.textColor = Theme.Color.Text.captionGrey
        amountTitleLabel.textColor = Theme.Color.Text.captionGrey
        paymentFeeTitleLabel.textColor = Theme.Color.Text.captionGrey
        medianWaitTitleLabel.textColor = Theme.Color.Text.captionGrey
        subtotalTitleLabel.textColor = Theme.Color.Text.captionGrey
        paymentFeeLowLabel.textColor = Theme.Color.Text.captionGrey
        paymentFeeMediumLabel.textColor = Theme.Color.Text.captionGrey
        paymentFeeHighLabel.textColor = Theme.Color.Text.captionGrey
        
        errorLabel.font = Theme.Font.smallText
        errorLabel.textColor = Theme.Color.Text.errorRed
        errorLabel.isHidden = true
        errorLabel.alpha = 0
        
        sendButton.isEnabled = false
        loaderView.isUserInteractionEnabled = false
    }
    
    private func localizeText() {
        receiverTitleLabel.text = LocalizedStrings.recepientAddressTitle
        receiverTextField.placeholder = LocalizedStrings.recepientInputPlaceholder
        scanQRButton.setTitle(LocalizedStrings.scanButtonTitle + "   ", for: .normal)
        
        amountTitleLabel.text = LocalizedStrings.amountTitle
        amountTextField.placeholder = LocalizedStrings.amountPlaceholder
        
        paymentFeeTitleLabel.text = LocalizedStrings.feeTitle
        medianWaitTitleLabel.text = LocalizedStrings.medianWaitTitle
        paymentFeeLowLabel.text = LocalizedStrings.lowFee
        paymentFeeMediumLabel.text = LocalizedStrings.mediumFee
        paymentFeeHighLabel.text = LocalizedStrings.highFee
        
        subtotalTitleLabel.text = LocalizedStrings.subtotalTitle
        sendButton.setTitle(LocalizedStrings.screenTitle, for: .normal)
    }
    
    private func setNavBarTransparency() {
        if let cellY = accountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
}


// MARK: Keyboard notifications

extension SendViewController {
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFinishedAnimating),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFinishedAnimating),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard amountTextField.isFirstResponder,
            let scrollView = scrollView, 
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        isKeyboardAnimating = true
        
        let keyboardOrigin = Constants.Sizes.screenHeight - keyboardFrame.cgRectValue.height
        let textFieldOrigin = amountTextField.convert(amountTextField.bounds, to: view).maxY + scrollView.contentOffset.y
        var delta = textFieldOrigin - keyboardOrigin + 8
        
        guard delta > 0 else { return }
        
        scrollView.contentOffset = CGPoint(x: 0, y: delta)
        
        if scrollView.contentSize.height < view.frame.height {
            delta += view.frame.height - scrollView.contentSize.height
        }
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: delta, right: 0)
        
        UIView.animate(withDuration: keyboardAnimationDelay) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        isKeyboardAnimating = true
        
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
    }
    
    @objc private func keyboardFinishedAnimating(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardAnimationDelay) { [weak self] in
            self?.isKeyboardAnimating = false
        }
    }
}
