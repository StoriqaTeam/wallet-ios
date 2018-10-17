//
//  ContactCell.swift
//  Wallet
//
//  Created by user on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet private var contactImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var phoneNumberLabel: UILabel!
    @IBOutlet private var emptyThumbnailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = contactImageView.frame.height / 2
        contactImageView.roundCorners(radius: radius)
        emptyThumbnailLabel.roundCorners(radius: radius)
    }
    
    func config(contact: ContactDisplayable) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.id
        
        if let image = contact.image {
            contactImageView.image = image
            emptyThumbnailLabel.isHidden = true
        } else {
            contactImageView.image = nil
            emptyThumbnailLabel.text = String(contact.givenName.prefix(1) + contact.familyName.prefix(1))
            emptyThumbnailLabel.sizeToFit()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contactImageView.image = nil
        emptyThumbnailLabel.isHidden = false
    }
    
}
