//
//  ExchangeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeViewController: UIViewController {
    
    typealias LocalizedStrings = Strings.Exchange

    var output: ExchangeViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var fromAccountsCollectionView: UICollectionView!
    @IBOutlet private var toAccountsCollectionView: UICollectionView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var fromAmountTitleLabel: UILabel!
    @IBOutlet private var fromAmountTextField: UITextField!
    @IBOutlet private var toAmountTitleLabel: UILabel!
    @IBOutlet private var toAmountTextField: UITextField!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var rateTimerLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var exchangeButton: GradientButton!
    
    // MARK: Variables

    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    private var shouldAnimateLayuot = false
    
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.fromAccountsCollectionView(fromAccountsCollectionView)
        output.toAccountsCollectionView(toAccountsCollectionView)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.configureCollections()
        output.viewWillAppear()
        setNavBarTransparency()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldAnimateLayuot = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        output.configureCollections()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: IBActions
    
    @IBAction private func fromAmountChanged(_ sender: UITextField) {
        output.fromAmountChanged(sender.text ?? "")
    }
    
    @IBAction private func toAmountChanged(_ sender: UITextField) {
        output.toAmountChanged(sender.text ?? "")
    }
    
    @IBAction func exchangeButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        output.exchangeButtonPressed()
    }

}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    
    func setupInitialState() {
        addNotificationObservers()
        addHideKeyboardGuesture()
        configInterface()
        localizeText()
    }
    
    func setFromAmount(_ amount: String) {
        fromAmountTextField.text = amount
    }
    
    func setToAmount(_ amount: String) {
        toAmountTextField.text = amount
    }
    
    func updateFromPlaceholder(_ placeholder: String) {
        fromAmountTextField.placeholder = placeholder
    }
    
    func updateToPlaceholder(_ placeholder: String) {
        toAmountTextField.placeholder = placeholder
    }
    
    func setErrorHidden(_ hidden: Bool) {
        if hidden {
            self.errorLabel.alpha = 0
            self.errorLabel.text = ""
        } else {
            self.errorLabel.alpha = 1
            self.errorLabel.text = LocalizedStrings.notEnoughFundsErrorLabel
        }
        
        if shouldAnimateLayuot {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    func showExchangeRateError(message: String) {
        self.errorLabel.alpha = 1
        self.errorLabel.text = message
        
        if shouldAnimateLayuot {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    func setAmount(_ amount: String) {
        toAmountTextField.text = amount
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        exchangeButton.isEnabled = enabled
    }
    
    func updateExpiredTimeLabel(_ time: String) {
        rateTimerLabel.text = time
    }
    
    func updateRateLabel(text: String) {
        UIView.transition(with: rateLabel, duration: 0.2, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
            self.rateLabel.text = text
        })
    }
}


// MARK: - UITextFieldDelegate

extension ExchangeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case fromAmountTextField:
            output.fromAmountDidBeginEditing()
        case toAmountTextField:
            output.toAmountDidBeginEditing()
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case fromAmountTextField:
            output.fromAmountDidEndEditing()
        case toAmountTextField:
            output.toAmountDidEndEditing()
        default: break
        }
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
        if !isKeyboardAnimating {
            dismissKeyboard()
        }
    }
}


// MARK: - Private methods

extension ExchangeViewController {
    
    private func setNavBarTransparency() {
        if let cellY = fromAccountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
    
    private func configInterface() {
        view.backgroundColor = Theme.Color.backgroundColor

        scrollView.delegate = self
        fromAmountTextField.delegate = self
        toAmountTextField.delegate = self
        
        fromAmountTitleLabel.font = Theme.Font.smallMediumWeightText
        toAmountTitleLabel.font = Theme.Font.smallMediumWeightText
        errorLabel.font = Theme.Font.smallText
        rateLabel.font = Theme.Font.regularMedium
        rateTimerLabel.font = Theme.Font.regularMedium
        fromAmountTextField.font = Theme.Font.input
        toAmountTextField.font = Theme.Font.input
        
        fromAmountTitleLabel.textColor = Theme.Color.Text.lightGrey
        toAmountTitleLabel.textColor = Theme.Color.Text.lightGrey
        rateLabel.textColor = Theme.Color.mainOrange
        errorLabel.textColor = Theme.Color.Text.errorRed
        rateTimerLabel.textColor = Theme.Color.Text.main
        
        errorLabel.text = ""
        errorLabel.alpha = 0
        exchangeButton.isEnabled = false
    }
    
    private func localizeText() {
        fromAmountTitleLabel.text = LocalizedStrings.fromAmountTitle
        toAmountTitleLabel.text = LocalizedStrings.toAmountTitle
        exchangeButton.setTitle(LocalizedStrings.exchangeButton, for: .normal)
    }
}


// MARK: Keyboard notifications

extension ExchangeViewController {
    
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
        guard toAmountTextField.isFirstResponder,
            let scrollView = scrollView,
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        isKeyboardAnimating = true
        
        let keyboardOrigin = Constants.Sizes.screenHeight - keyboardFrame.cgRectValue.height
        let textFieldOrigin = toAmountTextField.convert(toAmountTextField.bounds, to: view).maxY + scrollView.contentOffset.y
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
