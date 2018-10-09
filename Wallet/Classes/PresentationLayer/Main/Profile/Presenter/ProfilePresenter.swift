//
//  ProfilePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ProfilePresenter: NSObject {
    
    weak var view: ProfileViewInput!
    weak var output: ProfileModuleOutput?
    var interactor: ProfileInteractorInput!
    var router: ProfileRouterInput!
    
}


// MARK: - ProfileViewOutput

extension ProfilePresenter: ProfileViewOutput {

    func viewIsReady() {
        let user = interactor.getCurrentUser()
        let photo = user.photo ?? #imageLiteral(resourceName: "profilePhotoPlaceholder")
        let name = user.lastName + " " + user.firstName
        let hasPhone = !user.phone.isEmpty
        
        view.setupInitialState(photo: photo,
                               name: name,
                               email: user.email,
                               hasPhone: hasPhone,
                               phone: user.phone)
        configureNavigationBar()
    }

    func settingsButtonTapped() {
        router.showSettings(from: view.viewController)
    }
    
    func connectPhoneButtonTapped() {
        // TODO: connectPhoneButtonTapped
    }
    
    func signOutButtonTapped() {
        router.signOutConfirmPopUp(popUpDelegate: self, from: view.viewController)
    }
    
    func changePhoneButtonTapped() {
        // TODO: changePhoneButtonTapped
    }
    
    func photoTapped() {
        let alert = UIAlertController(title: "change_photo".localized(),
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "make_photo".localized(), style: .default) { _ in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "from_gallery".localized(), style: .default) { _ in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel)
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        showAlertVC(alert)
    }
    
}


// MARK: - ProfileInteractorOutput

extension ProfilePresenter: ProfileInteractorOutput {

}


// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {
    
    var viewController: UIViewController {
        return view.viewController
    }

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
    
}


// MARK: - PopUpSignOutVMDelegate

extension ProfilePresenter: PopUpSignOutVMDelegate {
    
    func signOut() {
        router.signOut()
    }
    
}


// MARK: UIImagePickerControllerDelegate

extension ProfilePresenter: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        view.viewController.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[.editedImage] as? UIImage {
            view.setPhoto(pickedImage)
            interactor.setNewPhoto(pickedImage)
        }
    }
    
}


// MARK: - Private methods

extension ProfilePresenter {
    
    private func configureNavigationBar() {
        view.viewController.setWhiteTextNavigationBar()
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.navigationController?.navigationBar.isTranslucent = true
        view.viewController.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    private func showAlertVC(_ alert: UIAlertController) {
        alert.view.tintColor = Theme.Color.brightSkyBlue
        view.viewController.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            view.viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            view.viewController.showAlert(message: "Camera not available")
        }
    }
    
    private func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            view.viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            view.viewController.showAlert(message: "Photos not available")
        }
    }
}
