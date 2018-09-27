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
    @IBOutlet private var receiverCurrencyTitleLabel: UILabel!
    @IBOutlet private var receiverCurrencySegmentedControl: CustomSegmentedControl!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var convertedAmountLabel: UILabel!
    @IBOutlet private var nextButton: DefaultButton!
    @IBOutlet private var scrollView: UIScrollView!
    
    
    // MARK: Variables
    
    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    
    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: Notification.Name.UITextFieldTextDidChange,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: Actions
    
    @IBAction private func receiverCurrencyChanged(_ sender: CustomSegmentedControl) {
        output.receiverCurrencyChanged(sender.selectedSegmentIndex)
    }
    
}


// MARK: - SendViewInput

extension SendViewController: SendViewInput {
    
    func setupInitialState(currencyImages: [UIImage]) {
        receiverCurrencySegmentedControl.buttonImages = currencyImages
        output.receiverCurrencyChanged(receiverCurrencySegmentedControl.selectedSegmentIndex)
    }
    
    func updateAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func updateConvertedAmount(_ amount: String) {
        convertedAmountLabel.text = amount
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        nextButton.isHidden = !enabled
    }
    
}


// MARK: - UITextFieldDelegate

extension SendViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = output.getAmountWithoutCurrency()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = output.getAmountWithCurrency()
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

extension SendViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isKeyboardAnimating {
            dismissKeyboard()
        }
    }
}


// MARK: - Private methods

extension SendViewController {
    
    private func configInterface() {
        amountTextField.delegate = self
        amountTextField.clearButtonMode = .never
        scrollView.delegate = self
        
        receiverCurrencyTitleLabel.font = UIFont.caption
        amountTitleLabel.font = UIFont.caption
        receiverCurrencyTitleLabel.textColor = UIColor.captionGrey
        amountTitleLabel.textColor = UIColor.captionGrey
        
        amountTitleLabel.text = "amount".localized()
        receiverCurrencyTitleLabel.text = "receiver_currency".localized()
        amountTextField.placeholder = "enter_amount".localized()
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        output.amountChanged(amountTextField.text ?? "")
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let delta = keyboardHeight - (view.frame.height - scrollView.contentSize.height) + 16
        
            isKeyboardAnimating = true
            
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = delta
            scrollView.contentInset = contentInset
            
            DispatchQueue.main.asyncAfter(deadline: .now() + keyboardAnimationDelay) { [weak self] in
                self?.isKeyboardAnimating = false
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardAnimating = true
        
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        
        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardAnimationDelay) { [weak self] in
            self?.isKeyboardAnimating = false
        }
    }
    
}


