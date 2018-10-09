//
//  User.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct User {
    let id: String
    let email: String
    var phone: String
    let firstName: String
    let lastName: String
    var photo: UIImage?
}


// MARK: - RealmMappable

extension User: RealmMappable {
    
    init(_ object: RealmUser) {
        self.id = object.id
        self.email = object.email
        self.phone = object.phone
        self.firstName = object.firstName
        self.lastName = object.lastName
        
        if let photoData = object.photo {
            let photo = UIImage(data: photoData)
            self.photo = photo
        } else {
            self.photo = nil
        }
    }
    
    func mapToRealmObject() -> RealmUser {
        let object = RealmUser()
        
        object.id = self.id
        object.email = self.email
        object.phone = self.phone
        object.firstName = self.firstName
        object.lastName = self.lastName
        object.photo = photo?.data()
        
        return object
    }
    
}

// MARK: Private UIImage extension

private extension UIImage {
    func data() -> Data? {
        if let data = self.pngData() ?? self.jpegData(compressionQuality: 1) {
            if data.count > 16 * 1024 * 1024 {
                let oldSize = self.size
                let newSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
                let newImage = self.imageWith(newSize: newSize)
                let imageData = newImage.jpegData(compressionQuality: 1)
                return imageData
            } else {
                return data
            }
        }
        return nil
    }
    
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        
        return image
    }
}
