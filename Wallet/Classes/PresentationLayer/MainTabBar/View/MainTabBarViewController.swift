//
//  MainTabBarViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MainTabBarViewController: UITabBarController {

    var output: MainTabBarViewOutput!


    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        output.viewIsReady()
    }
}


// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {
    var mainTabBar: UITabBarController? {
        return self
    }
    
    func setupInitialState() { }
}


// MARK: - Private methods

extension MainTabBarViewController {
    
    private func configureTabBar() {
        tabBar.isTranslucent = false
        tabBar.barTintColor = Theme.Color.TabBar.background
        tabBar.tintColor = Theme.Color.TabBar.selectedItem
        tabBar.unselectedItemTintColor = Theme.Color.TabBar.unselectedItem
        tabBar.backgroundColor = Theme.Color.TabBar.background
    }
}
