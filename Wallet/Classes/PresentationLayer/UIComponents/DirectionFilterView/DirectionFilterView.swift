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
    
    typealias LocalizedStrings = Strings.Transactions
    
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
        allLabel.textColor = Theme.Color.primaryGrey
        sentlabel.font = Theme.Font.FilterView.filterLabel
        sentlabel.textColor = Theme.Color.primaryGrey
        receivelabel.font = Theme.Font.FilterView.filterLabel
        receivelabel.textColor = Theme.Color.primaryGrey
        allUnderlineView.backgroundColor = Theme.Color.brightOrange
        sentUnderlineView.backgroundColor = Theme.Color.brightOrange
        receiveUnderlineView.backgroundColor = Theme.Color.brightOrange
        
        allLabel.isUserInteractionEnabled = true
        sentlabel.isUserInteractionEnabled = true
        receivelabel.isUserInteractionEnabled = true
        
        allLabel.text = LocalizedStrings.allButton
        sentlabel.text = LocalizedStrings.sentButton
        receivelabel.text = LocalizedStrings.receivedButton
    }
    
    private func setFilter(position: FilterPosition) {
        self.allLabel.textColor = Theme.Color.primaryGrey
        self.receivelabel.textColor = Theme.Color.primaryGrey
        self.sentlabel.textColor = Theme.Color.primaryGrey
        
        self.allUnderlineView.alpha = 0.0
        self.sentUnderlineView.alpha = 0.0
        self.receiveUnderlineView.alpha = 0.0
        
        self.allLabel.transform = .identity
        self.receivelabel.transform = .identity
        self.sentlabel.transform = .identity
        
        UIView.animate(withDuration: 0.2) {
            switch position {
            case .all:
                self.allLabel.textColor = Theme.Color.Text.main
                self.allLabel.transform = CGAffineTransform(scaleX: comcom, y: 1.3)
                self.allUnderlineView.alpha = 1.0
            
            case .sent:
                self.sentlabel.textColor = Theme.Color.Text.main
                self.sentlabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.sentUnderlineView.alpha = 1.0
                
            case .receive:
                self.receivelabel.textColor = Theme.Color.Text.main
                self.receivelabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.receiveUnderlineView.alpha = 1.0
            }
        }
        
        
    }
}
