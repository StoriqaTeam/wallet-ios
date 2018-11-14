//
//  SendViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    
    var output: SendViewOutput!
    
    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var gradientView: HeaderGradientView!
    @IBOutlet private var receiverTitleLabel: UILabel!
    @IBOutlet private var scanQRButton: UIButton!
    @IBOutlet private var receiverTextField: UnderlinedTextField!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
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
    
    
    // MARK: Variables
    
    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    private var currentSliderStep = 0 {
        didSet {
            if oldValue != currentSliderStep {
                output.newFeeSelected(currentSliderStep)
            }
        }
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configInterface()
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
        configureGradientView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Actions
    
    @IBAction private func amountDidChange(_ sender: UITextField) {
        output.amountChanged(sender.text ?? "")
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        output.sendButtonPressed()
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        output.scanButtonPressed()
    }
    
    @IBAction private func sliderMoved(_ sender: StepSlider) {
        currentSliderStep = sender.currentSliderStep
    }
}


// MARK: - SendViewInput

extension SendViewController: SendViewInput {
    
    func setupInitialState(numberOfPages: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
    }
    
    func setScannedAddress(_ address: String) {
        receiverTextField.text = address
    }
    
    func setSubtotal(_ subtotal: String) {
        subtotalLabel.text = subtotal
        
        if self.subtotalLabel.superview!.isHidden != subtotal.isEmpty {
            UIView.performWithoutAnimation {
                self.subtotalLabel.superview?.isHidden = subtotal.isEmpty
            }
        }
        
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
            self.errorLabel.text = "You haven’t got enough funds to send. Try to set another count."
            
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
        
        receiverTitleLabel.text = "receiver_address".localized()
        amountTitleLabel.text = "amount".localized()
        amountTextField.placeholder = "enter_amount".localized()
        
        receiverTextField.placeholder = "receiver_input_placeholder".localized()
        receiverTextField.autocorrectionType = .no
        scanQRButton.setTitle("scan_QR".localized() + "   ", for: .normal)
        sendButton.setTitle("send".localized(), for: .normal)
        
        receiverTitleLabel.font = Theme.Font.caption
        amountTitleLabel.font = Theme.Font.caption
        paymentFeeTitleLabel.font = Theme.Font.caption
        medianWaitTitleLabel.font = Theme.Font.caption
        subtotalTitleLabel.font = Theme.Font.caption
        paymentFeeLowLabel.font = Theme.Font.smallText
        paymentFeeMediumLabel.font = Theme.Font.smallText
        paymentFeeHighLabel.font = Theme.Font.smallText
        
        receiverTitleLabel.textColor = Theme.Text.Color.captionGrey
        amountTitleLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeTitleLabel.textColor = Theme.Text.Color.captionGrey
        medianWaitTitleLabel.textColor = Theme.Text.Color.captionGrey
        subtotalTitleLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeLowLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeMediumLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeHighLabel.textColor = Theme.Text.Color.captionGrey
        
        errorLabel.font = Theme.Font.smallText
        errorLabel.textColor = Theme.Text.Color.errorRed
        errorLabel.isHidden = true
        errorLabel.alpha = 0
        
        sendButton.isEnabled = false
    }
    
    private func configureGradientView() {
        let height = accountsCollectionView.frame.height +
            accountsPageControl.frame.height +
            (navigationController?.navigationBar.frame.size.height ?? 44) +
            UIApplication.shared.statusBarFrame.height
        
        gradientView.setHeight(height: height)
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard amountTextField.isFirstResponder,
            let scrollView = scrollView, 
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        isKeyboardAnimating = true
        
        let keyboardOrigin = Constants.Sizes.screenHeight - keyboardFrame.cgRectValue.height
        let textFieldOrigin = amountTextField.convert(amountTextField.bounds, to: view).maxY
        var delta = textFieldOrigin - keyboardOrigin + 8
        
        guard delta > 0 else { return }
        
        if scrollView.contentSize.height < view.frame.height {
            delta += view.frame.height - scrollView.contentSize.height
        }
        
        scrollView.contentOffset = CGPoint(x: 0, y: delta)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: delta, right: 0)
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
