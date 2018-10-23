//
//  PopUpInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PopUpInteractor {
    weak var output: PopUpInteractorOutput!
    
    private let viewModel: PopUpViewModelProtocol
    
    init(viewModel: PopUpViewModelProtocol) {
        self.viewModel = viewModel
    }
}


// MARK: - PopUpInteractorInput

extension PopUpInteractor: PopUpInteractorInput {
    
    func getViewModel() -> PopUpViewModelProtocol {
        return viewModel
    }
    
}
