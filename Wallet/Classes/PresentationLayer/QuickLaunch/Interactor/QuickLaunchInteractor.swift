//
//  QuickLaunchInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class QuickLaunchInteractor {
    weak var output: QuickLaunchInteractorOutput!
    
    private let qiuckLaunchProvider: QuickLaunchProviderProtocol
    init(qiuckLaunchProvider: QuickLaunchProviderProtocol) {
        self.qiuckLaunchProvider = qiuckLaunchProvider
    }
}


// MARK: - QuickLaunchInteractorInput

extension QuickLaunchInteractor: QuickLaunchInteractorInput {

}
