//
//  CustomSegmentedControl.swift
//  CustomSEgmentedControl
//
//  Created by Leela Prasad on 18/01/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//
import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {
    
    private var buttons = [UIButton]()
    private var selector: UIView!
    var selectedSegmentIndex = 0
    
    var buttonImages = [UIImage]() {
        didSet { updateView() }
    }
    
    @IBInspectable var imageColor: UIColor = .cloudyBlue {
        didSet { updateButtonColors() }
    }
    
    @IBInspectable var selectorColor: UIColor = .mainBlue {
        didSet {
            selector?.backgroundColor = selectorColor
        }
    }
    
    @IBInspectable var selectedImageColor: UIColor = .mainBlue {
        didSet { updateButtonColors() }
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex,btn) in buttons.enumerated() {
            if btn == button {
                selectedSegmentIndex = buttonIndex
                
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3, animations: {
                    self.selector.frame.origin.x = selectorStartPosition
                })
                btn.tintColor = selectedImageColor
            } else {
                btn.tintColor = imageColor
            }
        }
        
        sendActions(for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selector?.frame.size.width = frame.width / CGFloat(buttonImages.count)
    }
    
}


//MARK: - Private methods

extension CustomSegmentedControl {
    private func updateButtonColors() {
        for (buttonIndex,btn) in buttons.enumerated() {
            btn.tintColor = buttonIndex == selectedSegmentIndex ? selectedImageColor : imageColor
        }
    }
    
    private func updateView() {
        buttons.removeAll()
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for image in buttonImages {
            let button = UIButton.init(type: .custom)
            button.setImage(image, for: .normal)
            button.tintColor = imageColor
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons.first?.tintColor = selectedImageColor
        
        let selectorHeight: CGFloat = 2.0
        let selectorWidth = frame.width / CGFloat(buttonImages.count)
        let y = (self.frame.maxY - self.frame.minY) - selectorHeight
        
        selector = UIView(frame: CGRect(x: 0, y: y, width: selectorWidth, height: selectorHeight))
        selector.backgroundColor = selectorColor
        
        addSubview(selector)
        
        // Create a StackView
        
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
}
