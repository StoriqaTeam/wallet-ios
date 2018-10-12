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
    private(set) var selectedSegmentIndex = 0
    
    var buttonImages = [UIImage]() {
        didSet { updateView() }
    }
    
    @IBInspectable var imageColor: UIColor = Theme.Color.cloudyBlue {
        didSet { updateButtonColors() }
    }
    
    @IBInspectable var selectorColor: UIColor = Theme.Color.brightSkyBlue {
        didSet {
            selector?.backgroundColor = selectorColor
        }
    }
    
    @IBInspectable var selectedImageColor: UIColor = Theme.Color.brightSkyBlue {
        didSet { updateButtonColors() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selector?.frame.size.width = frame.width / CGFloat(buttonImages.count)
    }
    
    func setSelectedSegmentIndex(_ index: Int) {
        selectedSegmentIndex = index
        
        buttons.forEach { $0.tintColor = imageColor }
        buttons[index].tintColor = selectedImageColor
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)
        selector.frame.origin.x = selectorStartPosition
    }
    
}


// MARK: - Private methods

extension CustomSegmentedControl {
    
    private func updateButtonColors() {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.tintColor = buttonIndex == selectedSegmentIndex ? selectedImageColor : imageColor
        }
    }
    
    @objc private func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
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
    
    private func updateView() {
        buttons.removeAll()
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for image in buttonImages {
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            button.tintColor = imageColor
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons.first?.tintColor = selectedImageColor
        
        let selectorHeight: CGFloat = 2.0
        let selectorWidth = frame.width / CGFloat(buttonImages.count)
        let yPosition = (self.frame.maxY - self.frame.minY) - selectorHeight
        
        selector = UIView(frame: CGRect(x: 0, y: yPosition, width: selectorWidth, height: selectorHeight))
        selector.backgroundColor = selectorColor
        
        addSubview(selector)
        
        // Create a StackView
        
        let stackView = UIStackView(arrangedSubviews: buttons)
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
