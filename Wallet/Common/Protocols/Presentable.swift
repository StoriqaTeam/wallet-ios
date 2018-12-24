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
    func presentAsTransitioningNavController()
    func presentAsRoot()
    func present(from viewController: UIViewController)
    func presentModal(from viewController: UIViewController)
    func show(from viewController: UIViewController)
    func dismiss()
    func dismissModal()
    func dismissModal(completion: @escaping () -> Void)
    func dismissModal(animated: Bool, completion: @escaping () -> Void)
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
        navigation.configureDefaultNavigationBar()
        AppDelegate.currentWindow.rootViewController = navigation
    }
    
    func presentAsTransitioningNavController() {
        let transitioningNav = TransitionNavigationController(rootViewController: viewController)
        transitioningNav.configureDefaultNavigationBar()
        AppDelegate.currentWindow.rootViewController = transitioningNav
    }
    
    func presentAsRoot() {
        AppDelegate.currentWindow.rootViewController = viewController
    }
    
    func present(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(self, animated: true)
    }
    
    func presentModal(from viewController: UIViewController) {
        viewController.presentedViewController?.dismiss(animated: false, completion: nil)
        viewController.present(self, animated: false, completion: nil)
    }
    
    func show(from viewController: UIViewController) {
        viewController.show(self, sender: viewController)
    }
    
    func dismiss() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func dismissModal(completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
    
    func dismissModal(animated: Bool, completion: @escaping () -> Void) {
        dismiss(animated: animated, completion: completion)
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
