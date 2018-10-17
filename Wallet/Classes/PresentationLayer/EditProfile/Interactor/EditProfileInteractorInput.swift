//
//  EditProfileInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol EditProfileInteractorInput: class {
    func getCurrentUser() -> User
    func updateUser(firstName: String, lastName: String)
}
