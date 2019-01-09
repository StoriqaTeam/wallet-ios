//
//  PinSetupCollectionViewCell.swift
//  Wallet
//
//  Created by Storiqa on 12/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

enum PinSetupStep {
    case setPin
    case confirmPin
}


protocol PinSetupCollectionViewCellDelegate: class {
    func pinSet(input: String)
}

class PinSetupCollectionViewCell: UICollectionViewCell {
    
    var step: PinSetupStep = .setPin
    weak var delegate: PinSetupCollectionViewCellDelegate?
    
    @IBOutlet weak var pinSetupContainerView: PinContainerView!
    
    override func awakeFromNib() {
        configureContainerView()
        setDelegate()
    }
    
    func clearInput() {
        pinSetupContainerView.clearInput()
    }
}


// MARK: - PinInputContainerViewDelegate

extension PinSetupCollectionViewCell: PinInputCompleteProtocol {
    func pinInputComplete(input: String) {
        delegate?.pinSet(input: input)
    }
    
    func authWithBiometryTapped() {
        fatalError("No biometry auth in setup")
    }
}

// MARK: - Private methods

extension PinSetupCollectionViewCell {
    private func configureContainerView() {
        pinSetupContainerView.totalDotCount = 4
        pinSetupContainerView.touchAuthenticationEnabled = false
        pinSetupContainerView.tintColor = Theme.Color.Text.main
        pinSetupContainerView.highlightedColor = Theme.Color.Text.main.withAlphaComponent(0.1)
        pinSetupContainerView.unhighlightedColor = Theme.Color.Text.main.withAlphaComponent(0.2)
        pinSetupContainerView.textFont = Theme.Font.PinInput.number
        pinSetupContainerView.borderWidth = 0
        pinSetupContainerView.dotStrokeColor = .clear
    }
    
    private func setDelegate() {
        pinSetupContainerView.delegate = self
    }
}
