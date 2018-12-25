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
    @IBOutlet private var actionButton: LightButton!
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
    
    func setBackgroundBlur(image: UIImage) {
        let blurImageView = UIImageView(image: image)
        self.blurBackImageView = blurImageView
    }
    
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
            closeButton.isHidden = true
        }
    }
}


// MARK: - Private methods

extension PopUpViewController {
    private func configureInterface() {
        titleLabel.font = Theme.Font.PopUp.title
        textLabel.font = Theme.Font.PopUp.subtitle
        titleLabel.textColor = Theme.Color.Text.main
        textLabel.textColor = Theme.Color.Text.main.withAlphaComponent(0.66)
        actionButton.setup(color: Theme.Color.Text.main.withAlphaComponent(0.5), titleColor: Theme.Color.Text.main)
        actionButton.titleLabel?.font = Theme.Font.Button.buttonTitle
        closeButton.setTitleColor(Theme.Color.Text.main, for: .normal)
    }
}
