//
//  ProfileInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ProfileInteractorInput: class {
    func getCurrentUser() -> User
    func setNewPhoto(_ photo: UIImage)
    func isPinLoginEnabled() -> Bool
}
