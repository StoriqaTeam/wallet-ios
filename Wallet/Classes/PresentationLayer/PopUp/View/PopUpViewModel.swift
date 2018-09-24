//
//  PopUpViewModel.swift
//  Wallet
//
//  Created by user on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PopUpViewModelProtocol {
    var apperance: PopUpApperance { get }
    func performAction()
    func cancelAction()
}

extension PopUpViewModelProtocol {
    //in case of no cansel button
    func cancelAction() { }
}
