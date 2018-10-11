//
//  UIViewControllerExtension.swift
//  Wallet
//
//  Created by Storiqa on 16.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setDarkNavigationBarButtons() {
        setNavigationBarButtonsColor(.black)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setWhiteNavigationBarButtons() {
        setNavigationBarButtonsColor(.white)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setNavigationBarAlpha(_ alpha: CGFloat) {
        guard let navigationBar = navigationController?.navigationBar else {
            log.warn("navigationBar is nil")
            return
        }
        let color = navigationBar.tintColor.withAlphaComponent(alpha)
        setNavigationBarButtonsColor(color)
        
        if let navLabel = navigationItem.titleView as? UILabel {
            navLabel.textColor = color
        }
    }
    
    func setDarkNavigationBar(title: String) {
        setNavigationBar(title: title, color: .black)
    }
    
    func setWhiteNavigationBar(title: String) {
        setNavigationBar(title: title, color: .white)
    }
    
    func addHideKeyboardGuesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func wrapToNavigationController() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: self)
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        navigation.navigationBar.backgroundColor = .clear
        navigation.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBarButton")
        navigation.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBarButton")
        navigation.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "",
                                                                              style: .plain,
                                                                              target: nil,
                                                                              action: nil)
        return navigation
    }
    
}

//Actions
extension UIViewController {
    @IBAction func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @IBAction func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}

//Alerts
extension UIViewController {
    func showAlert(title: String = "", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Private methods

extension UIViewController {
    
    private func setNavigationBarButtonsColor(_ color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = color
    }
    
    private func setNavigationBar(title: String, color: UIColor) {
        let navLabel = UILabel()
        navLabel.backgroundColor = .clear
        navLabel.textColor = color
        navLabel.font = UIFont.navigationBarTitle
        navLabel.text = title
        navLabel.textAlignment = .center
        navLabel.sizeToFit()
        navigationItem.titleView = navLabel
        
        setNavigationBarButtonsColor(color)
    }
    
}

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
