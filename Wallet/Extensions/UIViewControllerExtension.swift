//
//  UIViewControllerExtension.swift
//  Wallet
//
//  Created by user on 16.08.2018.
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
    }
    
    private func setNavigationBarTextColor(_ color: UIColor) {
        guard let navigationBar = navigationController?.navigationBar else {
            log.warn("navigationBar is nil")
            return
        }
        
        navigationBar.barTintColor = color
        navigationBar.tintColor = color
        
        var titleTextAttributes = navigationBar.titleTextAttributes ?? [NSAttributedStringKey : Any]()
        titleTextAttributes[NSAttributedStringKey.foregroundColor] = color
        navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    func addHideKeyboardGuesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//Popup
extension UIViewController {
    func presentPopup(image: UIImage, title: String, text: String? = nil, attributedText: NSAttributedString? = nil, actionTitle: String, hasCloseButton: Bool = true, actionBlock: (()->())?) {
        if let popupVC = PopupViewController.create(image: image, title: title, text: text, attributedText: attributedText, actionTitle: actionTitle, actionBlock: actionBlock, hasCloseButton: hasCloseButton) {
            popupVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            present(popupVC, animated: true)
        } else {
            log.error("couldn't create PopupViewController")
        }
    }
}
