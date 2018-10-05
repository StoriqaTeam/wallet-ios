//
//  Presentable.swift
//  UniversaWallet
//
//  Created by Storiqa on 27/04/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

protocol Presentable {
    
    var viewController: UIViewController { get }
    var parent: UIViewController? { get }
    
    func present()
    func presentAsNavController()
    func presentAsRoot()
    func present(from viewController: UIViewController)
    func presentModal(from viewController: UIViewController)
    func show(from viewController: UIViewController)
    func dismiss()
    func dismissModal()
    func dismissModal(completion: @escaping () -> Void)
    func popToRoot()
    func present(in container: UIView, parent: UIViewController)
}

extension Presentable where Self: UIViewController {
    
    var viewController: UIViewController {
        return self
    }
    
    var parent: UIViewController? {
        return viewController.parent
    }
    
    func present() {
        AppDelegate.currentWindow.rootViewController = viewController
    }
    
    func presentAsNavController() {
        let navigation = UINavigationController(rootViewController: viewController)
        
        // Config nav bar
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        navigation.navigationBar.backgroundColor = .clear
        navigation.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "BackBarButton")
        navigation.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "BackBarButton")
        
        AppDelegate.currentWindow.rootViewController = navigation
    }
    
    func presentAsRoot() {
        AppDelegate.currentWindow.rootViewController = viewController
    }
    
    func present(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(self, animated: true)
    }
    
    func presentModal(from viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
    
    func show(from viewController: UIViewController) {
        viewController.show(self, sender: viewController)
    }
    
    func dismiss() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true) {
            completion()
        }
    }
    
    func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func popToRoot() {
        viewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func present(in container: UIView, parent: UIViewController) {
        parent.addChild(self)
        container.addSubview(view)
        didMove(toParent: parent)
    }
}
