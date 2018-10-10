//
//  ProfileViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ProfileViewInput: class, Presentable {
    func setupInitialState(photo: UIImage,
                           name: String,
                           email: String,
                           hasPhone: Bool,
                           phone: String?)
    
    func setPhoto(_ photo: UIImage)
    func setPhone(hasPhone: Bool, phone: String?)
}
