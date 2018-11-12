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
    @IBOutlet private var gradientView: HeaderGradientView!
    @IBOutlet private var errorLabel: UILabel!
    
    
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
    
    @IBAction private func textDidChange(_ sender: UITextField) {
        output.amountChanged(sender.text ?? "")
    }
    
    @IBAction private func receiverCurrencyChanged(_ sender: CustomSegmentedControl) {
        output.receiverCurrencyChanged(sender.selectedSegmentIndex)
    }
    
    @IBAction private func nextButtonPressed(_ sender: UIButton) {
        output.nextButtonPressed()
    }
}


// MARK: - SendViewInput

extension SendViewController: SendViewInput {
    func setupInitialState(currencyImages: [UIImage], numberOfPages: Int) {
        receiverCurrencySegmentedControl.buttonImages = currencyImages
        output.receiverCurrencyChanged(receiverCurrencySegmentedControl.selectedSegmentIndex)
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
        
        
        // FIXME: disabled before release
        receiverCurrencySegmentedControl.isUserInteractionEnabled = false
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
    }
    
    func setAmount(_ amount: String) {
        amountTextField.text = amount
    }
    
    func setConvertedAmount(_ amount: String) {
        convertedAmountLabel.text = amount
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
    }
    
    func setButtonEnabled(_ enabled: Bool) {
        nextButton.isHidden = !enabled
    }
    
    func setReceiverCurrencyIndex(_ index: Int) {
        guard receiverCurrencySegmentedControl.selectedSegmentIndex != index else {
            return
        }
        
        receiverCurrencySegmentedControl.setSelectedSegmentIndex(index)
    }
    
    func setButtonEnabled(_ enabled: Bool, errorHidden: Bool) {
        
        if enabled {
            nextButton.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.nextButton.alpha = 1
            }, completion: { finished in
                if finished {
                    self.nextButton.isHidden = false
                }
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.nextButton.alpha = 0
            }, completion: { finished in
                if finished {
                    self.nextButton.isHidden = true
                }
            })
        }
        
        if errorHidden {
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 0
            }, completion: { finished in
                if finished {
                    self.errorLabel.isHidden = true
                }
            })
        } else {
            self.errorLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
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
        amountTextField.clearButtonMode = .never
        scrollView.delegate = self
        
        receiverCurrencyTitleLabel.font = Theme.Font.caption
        amountTitleLabel.font = Theme.Font.caption
        receiverCurrencyTitleLabel.textColor = Theme.Text.Color.captionGrey
        amountTitleLabel.textColor = Theme.Text.Color.captionGrey
        
        amountTitleLabel.text = "amount".localized()
        receiverCurrencyTitleLabel.text = "receiver_currency".localized()
        amountTextField.placeholder = "enter_amount".localized()
        
        errorLabel.font = Theme.Font.smallText
        errorLabel.textColor = Theme.Text.Color.errorRed
        errorLabel.isHidden = true
        errorLabel.alpha = 0
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
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardOrigin = view.frame.height - keyboardFrame.cgRectValue.height
            let textFieldOrigin = amountTextField.superview!.convert(amountTextField.frame, to: view).maxY
            var delta = textFieldOrigin - keyboardOrigin + 16
            
            if scrollView.contentSize.height < view.frame.height {
                delta += view.frame.height - scrollView.contentSize.height
            }
            
            isKeyboardAnimating = true
            
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = delta
            scrollView.contentInset = contentInset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        isKeyboardAnimating = true
        
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        
    }
    
    @objc private func keyboardFinishedAnimating(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + keyboardAnimationDelay) { [weak self] in
            self?.isKeyboardAnimating = false
        }
    }
    
}
