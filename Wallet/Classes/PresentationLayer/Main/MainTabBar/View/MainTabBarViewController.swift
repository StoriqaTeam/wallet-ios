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
        tabBar.barTintColor = Theme.Color.white
        tabBar.tintColor = Theme.Color.brightSkyBlue
        tabBar.unselectedItemTintColor = Theme.Color.captionGrey.withAlphaComponent(0.4)
        tabBar.backgroundColor = UIColor(white: 0.82, alpha: 1)
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.shadowColor = Theme.Color.greyShadow.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -6)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.04
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0,
                                            width: Constants.Sizes.screenWith,
                                            height: Constants.Sizes.lineWidth))
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.35)
        tabBar.addSubview(lineView)
    }
}
