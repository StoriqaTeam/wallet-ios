//
//  PopUpInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PopUpInteractorInput: class {
    func getViewModel() -> PopUpViewModelProtocol
}
