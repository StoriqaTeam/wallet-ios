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
    @IBOutlet private var subtitleLabel: UILabel!
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        disableBackNavigation()
        output.pinSetupCollectionView(pinSetupCollectionView)
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
        subtitleLabel.textColor = Theme.Color.Text.main.withAlphaComponent(0.5)
        titleLabel.font = Theme.Font.title
        subtitleLabel.font = Theme.Font.subtitle
    }

    func setTitle(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
