//
//  AppInfoPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 28/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AppInfoPresenter {
    
    typealias LocalizedStrings = Strings.AppInfo
    
    weak var view: AppInfoViewInput!
    weak var output: AppInfoModuleOutput?
    var interactor: AppInfoInteractorInput!
    var router: AppInfoRouterInput!
    
}


// MARK: - AppInfoViewOutput

extension AppInfoPresenter: AppInfoViewOutput {

    func viewIsReady() {
        let dictionary = Bundle.main.infoDictionary!
        let displayName = dictionary["CFBundleDisplayName"] as? String ?? "unknown"
        let bundleId = dictionary["CFBundleIdentifier"] as? String ?? "unknown"
        let bundleVersion = dictionary["CFBundleVersion"] as? String ?? ""
        let appVersion = dictionary["CFBundleShortVersionString"] as? String ?? ""
        
        view.setupInitialState(displayName: displayName, bundleId: bundleId, appVersion: appVersion + "." + bundleVersion)
        configureNavigationBar()
    }

}


// MARK: - AppInfoInteractorOutput

extension AppInfoPresenter: AppInfoInteractorOutput {

}


// MARK: - AppInfoModuleInput

extension AppInfoPresenter: AppInfoModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private methods

extension AppInfoPresenter {
    func configureNavigationBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = LocalizedStrings.navigationBarTitle
    }
}
