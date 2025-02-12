//
//  TransactionFilterModuleViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionFilterViewController: UIViewController {
    typealias LocalizedStrings = Strings.TransactionFilter

    var output: TransactionFilterViewOutput!
    
    @IBOutlet private var fromTextField: UnderlinedTextField!
    @IBOutlet private var toTextField: UnderlinedTextField!
    @IBOutlet private var okButton: GradientButton!
    @IBOutlet private var clearFilterButton: ColoredFramelessButton!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionLabel: UILabel!
    
    private var fromDatePickerView: UIDatePicker!
    private var toDatePickerView: UIDatePicker!

    var isFirst = true

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.checkFilter()
    }
    
    
    // MARK: - Actions
    
    @IBAction func fromTextFieldEditing(_ sender: UnderlinedTextField) {
        
        fromTextField.inputView = fromDatePickerView
        fromTextField.inputView?.backgroundColor = .black
        
        if  fromTextField.text?.isEmpty ?? true {
            let dateFormatter = filterDateFormatter()
            fromTextField.text = dateFormatter.string(from: fromDatePickerView.date)
            output.didSelectFrom(date: fromDatePickerView.date)
        }
    }
    
    @IBAction func toTextFieldEditing(_ sender: UnderlinedTextField) {

        toTextField.inputView = toDatePickerView
        toTextField.inputView?.backgroundColor = .black
        
        if  toTextField.text?.isEmpty ?? true {
            let dateFormatter = filterDateFormatter()
            toTextField.text = dateFormatter.string(from: toDatePickerView.date)
            output.didSelectTo(date: toDatePickerView.date)
        }
    }
    
    @IBAction func clearFilterPressed(_ sender: Any) {
        clearUI()
        output.resetFilter()
        configureButtons(isEnable: false)
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        output.setFilter()
    }
}


// MARK: - TransactionFilterModuleViewInput

extension TransactionFilterViewController: TransactionFilterViewInput {
    func fillTextFileld(fromDate: Date, toDate: Date) {
        let dateFormatter = filterDateFormatter()
        fromTextField.text = dateFormatter.string(from: fromDate)
        toTextField.text = dateFormatter.string(from: toDate)
        
        fromTextField.inputView = fromDatePickerView
        fromDatePickerView.date = fromDate
        toDatePickerView.date = toDate
    }
    

    func setupInitialState() {
        configureDatePickers()
        addTargetsTextField()
        addNotificationObservers()
        configureAppearence()
    }
    
    func buttonsChangedState(isEnabled: Bool) {
        configureButtons(isEnable: isEnabled)
    }
}


// MARK: - Private methods

extension TransactionFilterViewController {
    
    private func configureAppearence() {
        view.backgroundColor = Theme.Color.backgroundColor
        descriptionLabel.textColor = .white
        descriptionLabel.font = Theme.Font.title
        descriptionLabel.text = LocalizedStrings.description
        fromTextField.placeholder = LocalizedStrings.fromPlaceholder
        toTextField.placeholder = LocalizedStrings.toPlaceholder
        okButton.setTitle(LocalizedStrings.okButton, for: .normal)
        clearFilterButton.setTitle(LocalizedStrings.clearButtonTitle, for: .normal)
    }
    
    @objc private func fromValueChanged(sender: UIDatePicker) {
        let date = sender.date
        let dateFormatter = filterDateFormatter()
        fromTextField.text = dateFormatter.string(from: date)
        output.didSelectFrom(date: date)
    }
    
    @objc private func toValueChanged(sender: UIDatePicker) {
        let date = sender.date
        let dateFormatter = filterDateFormatter()
        toTextField.text = dateFormatter.string(from: date)
        output.didSelectTo(date: date)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 49
        let height = fromDatePickerView.bounds.height - tabBarHeight
        
        if isFirst {
            fromTextField.inputView = fromDatePickerView
            fromTextField.inputView?.backgroundColor = .black
            toTextField.inputView = toDatePickerView
            toTextField.inputView?.backgroundColor = .black
            isFirst = false
        }
        
        var animationOptions = UIView.AnimationOptions()
        if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animationOptions.insert(UIView.AnimationOptions(rawValue: curve))
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.bottomConstraint.constant = height
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.2
        
        var animationOptions = UIView.AnimationOptions()
        if let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            animationOptions.insert(UIView.AnimationOptions(rawValue: curve))
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { [weak self] in
            self?.bottomConstraint.constant = 27
            self?.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    private func configureButtons(isEnable: Bool) {
        okButton.isEnabled = isEnable
        configureClearButton(isEnable: isEnable)
    }
    
    private func configureClearButton(isEnable: Bool) {
        let titleColor = isEnable ? Theme.Color.Button.tintColor : Theme.Color.Button.tintColor.withAlphaComponent(0.4)
        clearFilterButton.setTitleColor(titleColor, for: .normal)
        clearFilterButton.isEnabled = isEnable
    }
    
    private func addTargetsTextField() {
        fromDatePickerView.addTarget(self,
                                     action: #selector(self.fromValueChanged),
                                     for: .valueChanged)
        toDatePickerView.addTarget(self,
                                   action: #selector(self.toValueChanged),
                                   for: .valueChanged)
        
    }
    
    private func configureDatePickers() {
        fromDatePickerView = UIDatePicker()
        toDatePickerView = UIDatePicker()
        fromDatePickerView.datePickerMode = .date
        toDatePickerView.datePickerMode = .date
        
        fromDatePickerView.setValue(UIColor.white, forKeyPath: "textColor")
        toDatePickerView.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    private func filterDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    private func clearUI() {
        _ = fromTextField.resignFirstResponder()
        _ = toTextField.resignFirstResponder()
        fromTextField.text = ""
        toTextField.text = ""
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}
