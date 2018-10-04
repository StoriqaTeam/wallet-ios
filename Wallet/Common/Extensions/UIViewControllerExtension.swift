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
    func setDarkTextNavigationBar() {
        setNavigationBarTextColor(.black)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setWhiteTextNavigationBar() {
        setNavigationBarTextColor(.white)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setNavigationBarAlpha(_ alpha: CGFloat) {
        guard let navigationBar = navigationController?.navigationBar else {
            log.warn("navigationBar is nil")
            return
        }
        let customColor = navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        let color = customColor ?? UIColor.black
        let alphaColor = color.withAlphaComponent(alpha)
        
        setNavigationBarTextColor(alphaColor)
    }
    
    private func setNavigationBarTextColor(_ color: UIColor) {
        guard let navigationBar = navigationController?.navigationBar else {
            log.warn("navigationBar is nil")
            return
        }
        
        navigationBar.barTintColor = color
        navigationBar.tintColor = color
        
        var titleTextAttributes = navigationBar.titleTextAttributes ?? [NSAttributedString.Key : Any]()
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = color
        navigationBar.titleTextAttributes = titleTextAttributes
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
