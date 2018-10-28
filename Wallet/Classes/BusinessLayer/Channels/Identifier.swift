//
//  Identifier.swift
//  Channels
//
//  Created by Даниил Мирошниченко on 27/10/2018.
//  Copyright © 2018 Даниил Мирошниченко. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


struct Identifier: Hashable {
    private let id: String
    
    init(_ id: String) {
        self.id = id
    }
    
    init() {
        self.id = UUID().uuidString
    }
    
    
    // MARK: - Hashable
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (_ lhs: Identifier, _ rhs: Identifier) -> Bool {
        return lhs.id == rhs.id
    }
    
}


// MARK: - ExpressibleByStringLiteral

extension Identifier: ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    init(stringLiteral value: String) {
        self.id = value
    }
}
