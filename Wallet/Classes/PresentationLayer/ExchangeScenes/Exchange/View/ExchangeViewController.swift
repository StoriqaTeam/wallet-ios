//
//  ExchangeViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeViewController: UIViewController {

    typealias Localization = Strings.Exchange
    
    var output: ExchangeViewOutput!

    // MARK: IBOutlets
    
    @IBOutlet private var accountsCollectionView: UICollectionView!
    @IBOutlet private var accountsPageControl: UIPageControl!
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

    private let keyboardAnimationDelay = 0.5
    private var isKeyboardAnimating = false
    private let dimmingBackground = UIButton()
    private let accountsActionSheet = UITableView()
    private let animationDuration = 0.3
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
        output.accountsCollectionView(accountsCollectionView)
        output.accountsActionSheet(accountsActionSheet)
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
    
    @IBAction private func dimmingBackgroundTapped(_ sender: UIButton) {
        hideAccountsActionSheet()
    }
    
}


// MARK: - ExchangeViewInput

extension ExchangeViewController: ExchangeViewInput {
    
    func setupInitialState(numberOfPages: Int) {
        accountsPageControl.isUserInteractionEnabled = false
        accountsPageControl.numberOfPages = numberOfPages
        
        setupInitialActionSheet()
        addHideKeyboardGuesture()
        configInterface()
    }
    
    func updatePagesCount(_ count: Int) {
        accountsPageControl.numberOfPages = count
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
            }, completion: { _ in
                self.errorLabel.isHidden = true
            })
        } else {
            self.errorLabel.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                self.errorLabel.alpha = 1
                self.exchangeButton.alpha = 0
            }, completion: { _ in
                self.exchangeButton.isHidden = true
            })
            
            scrollToBottom()
        }
        
    }
    
    func setNewPage(_ index: Int) {
        accountsPageControl.currentPage = index
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
    
    func showAccountsActionSheet(height: CGFloat) {
        let yPosition = Constants.Sizes.screenHeight - height - 10
        self.setAccountsActionSheet(height: height)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.setAccountsActionSheet(yPosition: yPosition)
            self.dimmingBackground.alpha = 1
        })
    }
    
    func hideAccountsActionSheet() {
        let yPosition = Constants.Sizes.screenHeight + 100
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.setAccountsActionSheet(yPosition: yPosition)
        })
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.dimmingBackground.alpha = 0
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
        dismissKeyboard()
    }
}


// MARK: - Private methods

extension ExchangeViewController {
    
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
    
    private func setNavBarTransparency() {
        if let cellY = accountsCollectionView.layoutAttributesForItem(at: IndexPath(row: 0, section: 0))?.frame.origin.y {
            let scrollOffset = scrollView.contentOffset.y
            let delta = max(0, scrollOffset - cellY - 12)
            let alpha = 1 - (max(0, min(0.999, delta / 12)))
            
            setNavigationBarAlpha(alpha)
        }
    }
    
    private func setupInitialActionSheet() {
        let screenWidth = Constants.Sizes.screenWith
        let screenHeight = Constants.Sizes.screenHeight
        
        accountsActionSheet.frame = CGRect(x: 8, y: screenHeight + 100, width: screenWidth - 16, height: 0)
        accountsActionSheet.roundCorners(radius: 12)
        
        dimmingBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        dimmingBackground.backgroundColor = UIColor(red: 4/255, green: 4/255, blue: 15/255, alpha: 0.4)
        dimmingBackground.setTitleColor(.clear, for: .normal)
        dimmingBackground.addTarget(self, action: #selector(dimmingBackgroundTapped(_:)), for: .touchUpInside)
        dimmingBackground.alpha = 0
        
        UIApplication.shared.keyWindow!.addSubview(dimmingBackground)
        UIApplication.shared.keyWindow!.addSubview(accountsActionSheet)
    }
    
    private func setAccountsActionSheet(yPosition: CGFloat) {
        var frame = accountsActionSheet.frame
        frame.origin.y = yPosition
        accountsActionSheet.frame = frame
    }
    
    private func setAccountsActionSheet(height: CGFloat) {
        var frame = accountsActionSheet.frame
        frame.size.height = height
        accountsActionSheet.frame = frame
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let textFieldOrigin = amountTextField.convert(amountTextField.frame.origin, to: view).y
            let delta = textFieldOrigin - keyboardHeight + 16
            
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
    
    private func configInterface() {
        scrollView.delegate = self
        amountTextField.delegate = self
        amountTextField.clearButtonMode = .never
        
        recepientAccountTitleLabel.font = Theme.Font.caption
        amountTitleLabel.font = Theme.Font.caption
        paymentFeeTitleLabel.font = Theme.Font.caption
        medianWaitTitleLabel.font = Theme.Font.caption
        subtotalTitleLabel.font = Theme.Font.caption
        
        paymentFeeLowLabel.font = Theme.Font.smallText
        paymentFeeMediumLabel.font = Theme.Font.smallText
        paymentFeeHighLabel.font = Theme.Font.smallText
        errorLabel.font = Theme.Font.smallText
        
        recepientAccountLabel.font = Theme.Font.generalText
        amountTextField.font = Theme.Font.generalText
        
        recepientAccountTitleLabel.textColor = Theme.Color.bluegrey
        amountTitleLabel.textColor = Theme.Color.bluegrey
        paymentFeeTitleLabel.textColor = Theme.Color.bluegrey
        medianWaitTitleLabel.textColor = Theme.Color.bluegrey
        subtotalTitleLabel.textColor = Theme.Color.bluegrey
        
        paymentFeeLowLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeMediumLabel.textColor = Theme.Text.Color.captionGrey
        paymentFeeHighLabel.textColor = Theme.Text.Color.captionGrey
        
        errorLabel.textColor = Theme.Text.Color.errorRed
        
        errorLabel.isHidden = true
        exchangeButton.isHidden = false
        
        //TODO: локализации
        amountTitleLabel.text = Localization.amountTitle
        amountTextField.placeholder = Localization.amountPlaceholder
    }
}
