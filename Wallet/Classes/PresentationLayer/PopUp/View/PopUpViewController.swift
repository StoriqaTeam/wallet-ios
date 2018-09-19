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

    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var actionButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton!
    
    // MARK: - Variables

    private var actionBlock: (()->())?
    private var closeBlock: (()->())?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        configureInterface() 
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
    
    private func configureInterface() {
        containerView.roundCorners(radius: 7)
        titleLabel.font = UIFont.title
        textLabel.font = UIFont.smallText
        textLabel.textColor = UIColor.primaryGrey
        closeButton.setTitleColor(UIColor.mainBlue, for: .normal)
    }
    
    // MARK: - Action
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismissViewController()
        actionBlock?()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismissViewController()
        closeBlock?()
    }
    
}


// MARK: - PopUpViewInput

extension PopUpViewController: PopUpViewInput {
    
    func setupInitialState(apperance: PopUpApperance) {
        imageView.image = apperance.image
        titleLabel.text = apperance.title
        if let attributedText = apperance.attributedText {
            textLabel.attributedText = attributedText
        } else if let text = apperance.text {
            textLabel.text = text
        } else {
            textLabel.text = ""
        }
        actionButton.setTitle(apperance.actionButtonTitle, for: .normal)
        actionBlock = apperance.actionBlock
        closeBlock = apperance.closeBlock
        
        if !apperance.hasCloseButton {
            closeButton.removeFromSuperview()
        }
    }

}
