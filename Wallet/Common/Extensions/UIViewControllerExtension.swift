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
    
    func setNavigationBarAlpha(_ alpha: CGFloat) {
        guard let navigationBar = navigationController?.navigationBar,
            let navLabel = navigationItem.titleView as? UILabel else {
                log.warn("navigationBar is nil")
                return
        }
        
        let color = navigationBar.tintColor.withAlphaComponent(alpha)
        navLabel.textColor = color
    }
    
    func setHidableNavigationBar(title: String) {
        let navLabel = UILabel()
        navLabel.backgroundColor = .clear
        navLabel.textColor = Theme.Color.NavigationBar.title
        navLabel.font = Theme.Font.NavigationBar.title
        navLabel.text = title
        navLabel.textAlignment = .center
        navLabel.sizeToFit()
        navigationItem.titleView = navLabel
    }
    
    func addHideKeyboardGuesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    func wrapToNavigationController() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: self)
        navigation.configureDefaultNavigationBar()
        return navigation
    }
    
    
    func wrapToTransitiningNavigationController() -> TransitionNavigationController {
        let navigation = TransitionNavigationController()
        navigation.setViewControllers([self], animated: false)
        navigation.configureDefaultNavigationBar()
        return navigation
    }
    
}


extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
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
        alert.view.tintColor = Theme.Color.mainOrange
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String = "", message: String = "", success: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            success()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.view.tintColor = Theme.Color.mainOrange
        self.present(alert, animated: true, completion: nil)

    }
    
    func showOkAlert(title: String = "", message: String = "", success: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            success?()
        }
        
        alert.addAction(okAction)
        alert.view.tintColor = Theme.Color.mainOrange
        self.present(alert, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func configureDefaultNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBarButton")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBarButton")
        navigationBar.titleTextAttributes = [.foregroundColor: Theme.Color.NavigationBar.title,
                                             .font: Theme.Font.NavigationBar.title!]
        navigationBar.barTintColor = Theme.Color.NavigationBar.buttons
        navigationBar.tintColor = Theme.Color.NavigationBar.buttons
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.title = " "
    }
}
