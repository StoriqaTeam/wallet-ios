//
//  PinSetupViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinSetupViewController: UIViewController {
    var output: PinSetupViewOutput!

    @IBOutlet private var pinSetupCollectionView: UICollectionView!
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        disableBackNavigation()
        output.pinSetupCollectionView(pinSetupCollectionView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func disableBackNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
}


// MARK: - PinSetupViewInput

extension PinSetupViewController: PinSetupViewInput {
    
    func setupInitialState() {
        view.backgroundColor = Theme.Color.backgroundColor
        titleLabel.textColor = Theme.Color.Text.main

    }

    func setTitle(title: String) {
        titleLabel.text = title
    }
}
