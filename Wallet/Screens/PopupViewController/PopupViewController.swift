//
//  PopupViewController.swift
//  Wallet
//
//  Created by user on 13.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PopupViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var containerView: UIView! {
        didSet {
            containerView.roundCorners(radius: 7)
        }
    }
    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.title
        }
    }
    @IBOutlet private var textLabel: UILabel! {
        didSet {
            textLabel.font = UIFont.smallText
            textLabel.textColor = UIColor.primaryGrey
        }
    }
    @IBOutlet private var actionButton: DefaultButton!
    @IBOutlet private var closeButton: BaseButton! {
        didSet {
            closeButton.setTitleColor(UIColor.mainBlue, for: .normal)
        }
    }
    
    private var actionBlock: (()->())?
    
    static func create(image: UIImage, title: String, text: String? = nil, attributedText: NSAttributedString? = nil, actionTitle: String,
                       actionBlock: @escaping (()->()), hasCloseButton: Bool = true) -> PopupViewController? {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "PopupViewController", bundle: bundle)
        
        guard let vc = nib.instantiate(withOwner: self, options: nil).first as? PopupViewController else {
            return nil
        }
        vc.imageView.image = image
        vc.titleLabel.text = title
        if let attributedText = attributedText {
            vc.textLabel.attributedText = attributedText
        } else if let text = text {
            vc.textLabel.text = text
        } else {
            vc.textLabel.text = ""
        }
        vc.actionButton.setTitle(actionTitle, for: .normal)
        vc.actionBlock = actionBlock
        
        if !hasCloseButton {
            vc.closeButton.removeFromSuperview()
        }
        return vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.backgroundColor = .clear
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
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismissViewController()
        actionBlock?()
    }
}
