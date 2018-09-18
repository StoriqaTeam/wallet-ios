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
    func presentAsNavController(from fromViewController: UIViewController)
    func presentAsRoot()
    func present(from viewController: UIViewController)
    func presentModal(from viewController: UIViewController)
    func show(from viewController: UIViewController)
    func dismiss()
    func dismissModal()
    func dismissModal(completion: @escaping ()->())
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
    
    func presentAsNavController(from fromViewController: UIViewController) {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.isNavigationBarHidden = true
        fromViewController.present(navigation, animated: true, completion: nil)
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
    
    func dismissModal(completion: @escaping ()->()) {
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
        parent.addChildViewController(self)
        container.addSubview(view)
        didMove(toParentViewController: parent)
    }
}
