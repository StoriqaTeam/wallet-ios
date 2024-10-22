//
//  AlertView.swift
//  Wallet
//
//  Created by Storiqa on 27/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AlertViewDelegate: class {
    func didTapOkAction()
}


class AlertView: LoadableFromXib {
    
    @IBOutlet private var typeImageView: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var text: UILabel!
    @IBOutlet private var okActionButton: UIButton!
    @IBOutlet private var cancelActionButton: UIButton!
    
    weak var delegate: AlertViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearence()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearence()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func viewTapped(_ sender: Any) {
        delegate?.didTapOkAction()
    }
    
    func setTitle(_ title: String) {
        self.title.text = title
    }
    
    func setMessage(_ message: String) {
        text.text = message
    }
    
    func setAlertImage(_ image: UIImage?) {
        if let alertImage = image {
            typeImageView.image = alertImage
        }
    }
}

// MARK: Private methods

extension AlertView {
    func configureAppearence() {
        cancelActionButton.isHidden = true
        okActionButton.isHidden = true
        cancelActionButton.setTitle(Strings.PopUp.okButton, for: .normal)
        
        title.textColor = .white
        title.font = Theme.Font.title
        
        text.textColor = .white
        text.font = Theme.Font.subtitle
        text.text = ""
    }
}
