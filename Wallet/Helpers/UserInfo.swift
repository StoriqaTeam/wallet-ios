//
//  UserInfo.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import UIKit

class UserInfo {
    static let shared = UserInfo()
    private init() {}
    
    var isAuth = false
    var token = ""
    
    //TODO: заменить на реальные данные
    var photo = #imageLiteral(resourceName: "faceid")
    var name = "Dmitrii"
    
    func clear() {
        isAuth = false
        token = ""
    }
}
