//
//  PopUpViewModel.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpViewModelProtocol {
    typealias Localization = Strings.PopUp
    
    var apperance: PopUpApperance { get }
    func performAction()
    func cancelAction()
}

extension PopUpViewModelProtocol {
    //in case of no cancel button
    func cancelAction() { }
}
