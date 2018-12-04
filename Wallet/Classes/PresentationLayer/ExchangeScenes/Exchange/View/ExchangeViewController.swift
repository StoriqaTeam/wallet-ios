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
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var recepientAccountTitleLabel: UILabel!
    @IBOutlet private var recepientAccountLabel: UILabel!
    @IBOutlet private var recepientBalanceLabel: UILabel!
    @IBOutlet private var amountTitleLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var rateTimerLabel: UILabel!
    @IBOutlet private var rateBackgroundView: UIView!
    @IBOutlet private var subtotalTitleLabel: UILabel!
    @IBOutlet private var subtotalLabel: UILabel!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var exchangeButton: DefaultButton!
    
    // MARK: Variables

    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setSubtotal(_ subtotal: String) {
        subtotalLabel.text = subtotal
    }
    
    func setErrorHidden(_ hidden: Bool) {
        if hidden {
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
            self.errorLabel.text = "not_enough_funds".localized()
            
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
    
    func showEchangeRateError(message: String) {
        self.errorLabel.isHidden = false
        self.errorLabel.text = message
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutSubviews()
            self.errorLabel.alpha = 1
        }, completion: { finished in
            if finished {
                self.errorLabel.isHidden = false
            }
        })
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
        rateLabel.text = text
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
        scrollView.delegate = self
        amountTextField.delegate = self
        
        recepientAccountTitleLabel.font = Theme.Font.caption
        amountTitleLabel.font = Theme.Font.caption
        subtotalTitleLabel.font = Theme.Font.caption
        
        errorLabel.font = Theme.Font.smallText
        recepientBalanceLabel.font = Theme.Font.smallText
        rateLabel.font = Theme.Font.smallText
        rateTimerLabel.font = Theme.Font.smallMediumWeightText
        
        recepientAccountLabel.font = Theme.Font.generalText
        amountTextField.font = Theme.Font.generalText
        
        recepientAccountTitleLabel.textColor = Theme.Color.bluegrey
        amountTitleLabel.textColor = Theme.Color.bluegrey
        subtotalTitleLabel.textColor = Theme.Color.bluegrey
        
        recepientBalanceLabel.textColor = Theme.Text.Color.captionGrey
        rateLabel.textColor = Theme.Text.Color.captionGrey
        rateTimerLabel.textColor = Theme.Text.Color.captionGrey
        
        errorLabel.textColor = Theme.Text.Color.errorRed
        
        errorLabel.text = ""
        errorLabel.isHidden = true
        exchangeButton.isEnabled = false
        
        //TODO: локализации
        amountTitleLabel.text = "amount".localized()
        amountTextField.placeholder = "enter_amount".localized()
        
        rateBackgroundView.roundCorners(radius: 10)
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
