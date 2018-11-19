//
//  Data+Helpers.swift
//  Wallet
//
//  Created by Storiqa on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
    
    public var unsafeByteArray: UnsafePointer<UInt8> {
        return withUnsafeBytes { return $0 }
    }
    
    public var unsafeBytes: UnsafeRawPointer {
        return withUnsafeBytes { UnsafeRawPointer($0) }
    }
    
    public var rawBytes: UnsafeRawPointer {
        return self.unsafeBytes
    }
    
    public var bytes: [UInt8] {
        return Array(self)
    }
    
    public var hex: String {
        return self.map { String(format: "%02hhx", $0) }.joined()
    }
    
}

extension Data {
    public init(hexString: String) {
        self.init(bytes: [UInt8](hex: hexString))
    }
    
}
