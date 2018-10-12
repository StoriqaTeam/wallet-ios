//
//  PopUpViewController.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var output: PopUpViewOutput!
    var viewModel: PopUpViewModelProtocol!

    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var actionButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton!
    @IBOutlet private var verticalCenterConstraint: NSLayoutConstraint!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight
        configureInterface()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        verticalCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Action
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        animateDismiss()
        viewModel.performAction()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        animateDismiss()
        viewModel.cancelAction()
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
        containerView.roundCorners(radius: 7)
        titleLabel.font = Theme.Font.title
        textLabel.font = Theme.Font.smallText
        textLabel.textColor = Theme.Color.primaryGrey
        closeButton.setTitleColor(Theme.Color.brightSkyBlue, for: .normal)
    }
    
    private func animateDismiss() {
        verticalCenterConstraint.constant = Constants.Sizes.screenHeight
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.view.backgroundColor = .clear
        }, completion: nil)
    }
    
}
