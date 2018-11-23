//
//  PopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class PopUpViewController: BasePopUpViewController {
    
    var output: PopUpViewOutput!
    var viewModel: PopUpViewModelProtocol!
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var actionButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        output.viewIsReady()
    }
    
    // MARK: - Action
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        animateDismiss { [weak self] in
            self?.viewModel.performAction()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        animateDismiss { [weak self] in
            self?.viewModel.cancelAction()
        }
    }
}


// MARK: - PopUpViewInput

extension PopUpViewController: PopUpViewInput {
    
    func setupInitialState(viewModel: PopUpViewModelProtocol) {
        self.viewModel = viewModel
        
        imageView.image = viewModel.apperance.image
        titleLabel.text = viewModel.apperance.title
        if let attributedText = viewModel.apperance.attributedText {
            textLabel.attributedText = attributedText
        } else if let text = viewModel.apperance.text {
            textLabel.text = text
        } else {
            textLabel.text = ""
        }
        actionButton.setTitle(viewModel.apperance.actionButtonTitle, for: .normal)
        closeButton.setTitle(viewModel.apperance.closeButtonTitle, for: .normal)
        
        if !viewModel.apperance.hasCloseButton {
            closeButton.removeFromSuperview()
        }
    }
}


// MARK: - Private methods

extension PopUpViewController {
    private func configureInterface() {
        titleLabel.font = Theme.Font.title
        textLabel.font = Theme.Font.smallText
        textLabel.textColor = Theme.Color.primaryGrey
        closeButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
    }
}
