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
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var recepientAccountTitleLabel: UILabel!
    @IBOutlet private var recepientAccountLabel: UILabel!
    @IBOutlet private var recepientBalanceLabel: UILabel!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var rateTimerLabel: UILabel!
    @IBOutlet private var giveTitleLabel: UILabel!
    @IBOutlet private var giveLabel: UILabel!
    @IBOutlet private var getTitleLabel: UILabel!
    @IBOutlet private var getLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var exchangeButton: DefaultButton!
    @IBOutlet private var dataContainerBackground: UIView!
    
    // MARK: Variables

    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    private var shouldAnimateLayuot = false
    
    
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
    
    @IBAction private func textDidChange(_ sender: UITextField) {
        output.amountChanged(sender.text ?? "")
    }
    
    @IBAction private func recepientAccountPressed(_ sender: UIButton) {
        output.recepientAccountPressed()
    }
    
    @IBAction func exchangeButtonPressed(_ sender: UIButton) {
        output.exchangeButtonPressed()
    }

}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    
    func setupInitialState(numberOfPages: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
        
        addNotificationObservers()
        addHideKeyboardGuesture()
        configInterface()
        localizeText()
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setGive(_ amount: String) {
        UIView.transition(with: giveLabel, duration: 0.2, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
            self.giveLabel.text = amount
        })
    }
    
    func setGet(_ amount: String) {
        UIView.transition(with: getLabel, duration: 0.2, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
            self.getLabel.text = amount
        })
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
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }
    
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func setRecepientAccount(_ recepient: String) {
        recepientAccountLabel.text = recepient
    }
    
    func setRecepientBalance(_ balance: String) {
        recepientBalanceLabel.text = balance
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
        if !isKeyboardAnimating {
            dismissKeyboard()
        }
    }
}


// MARK: - Private methods

extension ExchangeViewController {
    
    private func setNavBarTransparency() {
        if let cellY = accountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
    
    private func configInterface() {
        view.backgroundColor = Theme.Color.backgroundColor
        dataContainerBackground.backgroundColor = Theme.Color.Text.main.withAlphaComponent(0.05)

        scrollView.delegate = self
        amountTextField.delegate = self
        
        recepientAccountTitleLabel.font = Theme.Font.smallMediumWeightText
        amountTitleLabel.font = Theme.Font.smallMediumWeightText
        giveTitleLabel.font = Theme.Font.smallMediumWeightText
        getTitleLabel.font = Theme.Font.smallMediumWeightText
        recepientBalanceLabel.font = Theme.Font.smallMediumWeightText
        errorLabel.font = Theme.Font.smallText
        rateLabel.font = Theme.Font.Label.medium
        rateTimerLabel.font = Theme.Font.Label.medium
        recepientAccountLabel.font = Theme.Font.input
        amountTextField.font = Theme.Font.input
        giveLabel.font = Theme.Font.input
        getLabel.font = Theme.Font.input
        
        recepientAccountTitleLabel.textColor = Theme.Color.Text.lightGrey
        amountTitleLabel.textColor = Theme.Color.Text.lightGrey
        giveTitleLabel.textColor = Theme.Color.Text.lightGrey
        getTitleLabel.textColor = Theme.Color.Text.lightGrey
        recepientBalanceLabel.textColor = Theme.Color.Text.lightGrey.withAlphaComponent(0.8)
        rateLabel.textColor = Theme.Color.mainOrange
        errorLabel.textColor = Theme.Color.Text.errorRed
        rateTimerLabel.textColor = Theme.Color.Text.main
        recepientAccountLabel.textColor = Theme.Color.Text.main
        giveLabel.textColor = Theme.Color.Text.main
        getLabel.textColor = Theme.Color.Text.main
        
        errorLabel.text = ""
        errorLabel.alpha = 0
        exchangeButton.isEnabled = false
    }
    
    private func localizeText() {
        recepientAccountTitleLabel.text = LocalizedStrings.toAccountTitle
        giveTitleLabel.text = LocalizedStrings.giveTitle
        getTitleLabel.text = LocalizedStrings.getTitle
        amountTitleLabel.text = LocalizedStrings.amountTitle
        amountTextField.placeholder = LocalizedStrings.amountPlaceholder
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
