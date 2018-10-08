//
//  Mappable.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol Mappable {
    associatedtype FromObj
    associatedtype ToObj
    
    func map(from obj: FromObj) -> ToObj
}
