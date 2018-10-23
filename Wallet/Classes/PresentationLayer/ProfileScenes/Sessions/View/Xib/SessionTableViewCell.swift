//
//  SessionTableViewCell.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SessionTableViewCell: UITableViewCell {
    
    @IBOutlet private var deviceLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    
    func configure(session: Session) {
        let dateFormatter = sessionDateFormatter()
        let date = session.date
        
        dateLabel.text = dateFormatter.string(from: date)
        deviceLabel.text = session.device.rawValue        
    }
}


// MARK: - Private methods

extension SessionTableViewCell {
    private func sessionDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}
