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
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.curveEaseIn], animations: { [weak self] in
            self?.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations:{[weak self] in
            self?.view.backgroundColor = .clear
            }, completion: nil)
    }
    
    // MARK: - Action
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismissViewController()
        viewModel.performAction()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismissViewController()
        viewModel.cancelAction()
    }
    
}


// MARK: - PopUpViewInput

extension PopUpViewController: PopUpViewInput {
    
    func setupInitialState(vm: PopUpViewModelProtocol) {
        self.viewModel = vm
        
        imageView.image = vm.apperance.image
        titleLabel.text = vm.apperance.title
        if let attributedText = vm.apperance.attributedText {
            textLabel.attributedText = attributedText
        } else if let text = vm.apperance.text {
            textLabel.text = text
        } else {
            textLabel.text = ""
        }
        actionButton.setTitle(vm.apperance.actionButtonTitle, for: .normal)
        
        if !vm.apperance.hasCloseButton {
            closeButton.removeFromSuperview()
        }
    }
}


// MARK: - Private methods

extension PopUpViewController {
    
    private func configureInterface() {
        containerView.roundCorners(radius: 7)
        titleLabel.font = UIFont.title
        textLabel.font = UIFont.smallText
        textLabel.textColor = UIColor.primaryGrey
        closeButton.setTitleColor(UIColor.mainBlue, for: .normal)
    }
    
}

