//
//  EditProfilePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EditProfilePresenter {
    
    weak var view: EditProfileViewInput!
    weak var output: EditProfileModuleOutput?
    var interactor: EditProfileInteractorInput!
    var router: EditProfileRouterInput!
    
}


// MARK: - EditProfileViewOutput

extension EditProfilePresenter: EditProfileViewOutput {

    func viewIsReady() {
        let user = interactor.getCurrentUser()
        view.setupInitialState(firstName: user.firstName, lastName: user.lastName)
        configureNavigtionBar()
    }
    
    func saveButtonTapped(firstName: String, lastName: String) {
        interactor.updateUser(firstName: firstName, lastName: lastName)
        view.dismiss()
    }
    
    func valuesChanged(firstName: String?, lastName: String?) {
        guard let firstName = firstName,
            let lastName = lastName else {
                view.setButtonEnabled(false)
            return
        }
        
        let valid = !firstName.isEmpty && !lastName.isEmpty
        view.setButtonEnabled(valid)
    }

}


// MARK: - EditProfileInteractorOutput

extension EditProfilePresenter: EditProfileInteractorOutput {

}


// MARK: - EditProfileModuleInput

extension EditProfilePresenter: EditProfileModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private metods

extension EditProfilePresenter {
    private func configureNavigtionBar() {
        view.viewController.title = "Edit profile"
    }
}