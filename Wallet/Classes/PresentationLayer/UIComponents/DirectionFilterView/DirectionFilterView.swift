//
//  DirectionFilterView.swift
//  Wallet
//
//  Created by Storiqa on 24/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

enum FilterPosition: Int {
    case all, sent, receive
}

protocol DirectionFilterDelegate: class {
    func didSet(positionIndex: Int)
}

class DirectionFilterView: LoadableFromXib {
    
    weak var delegate: DirectionFilterDelegate!
    
    enum FilterPosition: Int {
        case all, sent, receive
    }
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var sentlabel: UILabel!
    @IBOutlet weak var receivelabel: UILabel!
    @IBOutlet weak var allUnderlineView: UIView!
    @IBOutlet weak var sentUnderlineView: UIView!
    @IBOutlet weak var receiveUnderlineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearence()
    }
    
    func setInitialFilter(position: FilterPosition) {
        setFilter(position: position)
    }
    
    @IBAction func allTapped(_ sender: UITapGestureRecognizer) {
        setFilter(position: .all)
        delegate.didSet(positionIndex: FilterPosition.all.rawValue)
    }
    
    @IBAction func sentTapped(_ sender: UITapGestureRecognizer) {
        setFilter(position: .sent)
        delegate.didSet(positionIndex: FilterPosition.sent.rawValue)
    }
    
    @IBAction func receiveTapped(_ sender: UITapGestureRecognizer) {
        setFilter(position: .receive)
        delegate.didSet(positionIndex: FilterPosition.receive.rawValue)
    }
}


// MARK: - Private methods

extension DirectionFilterView {
    private func configureAppearence() {
        contentView.backgroundColor = Theme.Color.backgroundColor
        allLabel.font = Theme.Font.FilterView.filterLabel
        allLabel.textColor = Theme.Color.Text.lightGrey
        sentlabel.font = Theme.Font.FilterView.filterLabel
        sentlabel.textColor = Theme.Color.Text.lightGrey
        receivelabel.font = Theme.Font.FilterView.filterLabel
        receivelabel.textColor = Theme.Color.Text.lightGrey
        allUnderlineView.backgroundColor = Theme.Color.brightOrange
        sentUnderlineView.backgroundColor = Theme.Color.brightOrange
        receiveUnderlineView.backgroundColor = Theme.Color.brightOrange
        
        allLabel.isUserInteractionEnabled = true
        sentlabel.isUserInteractionEnabled = true
        receivelabel.isUserInteractionEnabled = true
    }
    
    private func setFilter(position: FilterPosition) {
        UIView.animate(withDuration: 0.2) {
            switch position {
            case .all:
                self.allLabel.textColor = .white
                self.receivelabel.textColor = Theme.Color.Text.lightGrey
                self.sentlabel.textColor = Theme.Color.Text.lightGrey
                
                self.allUnderlineView.alpha = 1.0
                self.sentUnderlineView.alpha = 0.0
                self.receiveUnderlineView.alpha = 0.0
                
                self.allLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.receivelabel.transform = .identity
                self.sentlabel.transform = .identity
                
                self.allUnderlineView.frame = CGRect(x: self.allLabel.frame.origin.x,
                                                     y: self.allUnderlineView.frame.origin.y,
                                                     width: self.allLabel.frame.width,
                                                     height: self.allUnderlineView.frame.height)
            
            case .sent:
                self.allLabel.textColor = Theme.Color.Text.lightGrey
                self.receivelabel.textColor = Theme.Color.Text.lightGrey
                self.sentlabel.textColor = .white
                self.allUnderlineView.alpha = 0.0
                self.sentUnderlineView.alpha = 1.0
                self.receiveUnderlineView.alpha = 0.0
                
                self.allLabel.transform = .identity
                self.receivelabel.transform = .identity
                self.sentlabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                
                self.sentUnderlineView.frame = CGRect(x: self.sentlabel.frame.origin.x,
                                                      y: self.sentUnderlineView.frame.origin.y,
                                                      width: self.sentlabel.frame.width,
                                                      height: self.sentUnderlineView.frame.height)
                
            case .receive:
                self.allLabel.textColor = Theme.Color.Text.lightGrey
                self.receivelabel.textColor = .white
                self.sentlabel.textColor = Theme.Color.Text.lightGrey
                
                self.allUnderlineView.alpha = 0.0
                self.sentUnderlineView.alpha = 0.0
                self.receiveUnderlineView.alpha = 1.0
                
                self.allLabel.transform = .identity
                self.receivelabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.sentlabel.transform = .identity
                
                self.receiveUnderlineView.frame = CGRect(x: self.receivelabel.frame.origin.x,
                                                         y: self.receiveUnderlineView.frame.origin.y,
                                                         width: self.receivelabel.frame.width,
                                                         height: self.receiveUnderlineView.frame.height)
            }
        }
    }
}
