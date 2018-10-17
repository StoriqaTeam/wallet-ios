//
//  TransactionFilterModuleViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionFilterViewController: UIViewController {

    var output: TransactionFilterViewOutput!
    
    @IBOutlet private var fromTextField: UnderlinedTextField!
    @IBOutlet private var toTextField: UnderlinedTextField!
    @IBOutlet private var okButton: DefaultButton!
    @IBOutlet private var clearFilterButton: UIButton!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    
    private var fromDatePickerView: UIDatePicker!
    private var toDatePickerView: UIDatePicker!
    

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.checkFilter()
    }
    
    
    // MARK: - Actions
    
    @IBAction func fromTextFieldEditing(_ sender: UnderlinedTextField) {
        fromTextField.inputView = fromDatePickerView
        
        if  fromTextField.text?.isEmpty ?? true {
            let dateFormatter = filterDateFormatter()
            fromTextField.text = dateFormatter.string(from: toDatePickerView.date)
        }

        fromDatePickerView.addTarget(self,
                                     action: #selector(self.fromValueChanged),
                                     for: .valueChanged)
    }
    
    @IBAction func toTextFieldEditing(_ sender: UnderlinedTextField) {
        toTextField.inputView = toDatePickerView
        
        if  toTextField.text?.isEmpty ?? true {
            let dateFormatter = filterDateFormatter()
            toTextField.text = dateFormatter.string(from: toDatePickerView.date)
        }

        toDatePickerView.addTarget(self,
                                   action: #selector(self.toValueChanged),
                                   for: .valueChanged)
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
    }
    

    func setupInitialState() {
        configureDatePickers()
        addNotificationObservers()
    }
    
    func buttonsChangedState(isEnabled: Bool) {
        configureButtons(isEnable: isEnabled)
    }

}


// MARK: - Private methods

extension TransactionFilterViewController {
    
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
        clearFilterButton.isEnabled = isEnable
        if isEnable {
            clearFilterButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
            return
        }
        
        clearFilterButton.setTitleColor(Theme.Button.Color.disabledTitle, for: .normal)
    }
    
    private func configureDatePickers() {
        fromDatePickerView = UIDatePicker()
        toDatePickerView = UIDatePicker()
        
        fromDatePickerView.datePickerMode = .date
        fromDatePickerView.backgroundColor = .white
        
        toDatePickerView.datePickerMode = .date
        toDatePickerView.backgroundColor = .white
    }
    
    private func filterDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    private func clearUI() {
        fromTextField.resignFirstResponder()
        toTextField.resignFirstResponder()
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
