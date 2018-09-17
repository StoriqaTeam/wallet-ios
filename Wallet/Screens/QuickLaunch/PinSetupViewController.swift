//
//  PinSetupViewController.swift
//  Wallet
//
//  Created by user on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PinSetupViewController: UIViewController {
    @IBOutlet private var passwordStackView: UIStackView!
    
    //MARK: Property
    private var passwordContainerView: PasswordContainerView!
    private let kPasswordDigit = 4
    
    private var isFirstEntry = true
    private var pinCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "enter_pin".localized()
        
        //create PasswordContainerView
        passwordContainerView = PasswordContainerView.create(in: passwordStackView, digit: kPasswordDigit, defaultHeight: 450)
        passwordContainerView.delegate = self
        passwordContainerView.touchAuthenticationEnabled = false
        
        //customize password UI
        passwordContainerView.tintColor = UIColor.mainBlue
        passwordContainerView.highlightedColor = UIColor.mainBlue
    }
    
}

extension PinSetupViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
        if isFirstEntry {
            isFirstEntry = false
            pinCode = input
            
            //TODO: нужна ли какая-то анимация или сообщение при переходе на следующий экран
            let deadlineTime = DispatchTime.now() + .milliseconds(500)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {[weak self] in
                guard let strongSelf = self else {
                    log.error("self is nil")
                    return
                }
                passwordContainerView.clearInput()
                strongSelf.title = "confirm_pin".localized()
            }
            
        } else {
            if input == pinCode {
                //TODO: сохранять пин и данные для входа в кейчейн
                
                guard let navigationController = navigationController else {
                    log.warn("navigationController is nil")
                    return
                }
                
                if let vc = Storyboard.quickLaunch.viewController(identifier: "TouchIdQuickLaunchVC") {
                    var viewControllers = navigationController.viewControllers
                    viewControllers.removeLast()
                    viewControllers.append(vc)
                    navigationController.setViewControllers(viewControllers, animated: true)
                }
                
            } else {
                //TODO: message
                showAlert(message: "pins_not_match_alert".localized())
                
                isFirstEntry = true
                passwordContainerView.clearInput()
                title = "enter_pin".localized()
            }
        }
    }
    
    func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) { }
}

