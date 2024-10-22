//
//  EditProfileInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol EditProfileInteractorOutput: class {
    func userUpdatedSuccessfully()
    func userUpdateFailed(message: String)
}
