//
//  NetworkErrorResolver.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol NetworkErrorResolverProtocol {
    func resolve(code: Int, json: JSON) -> Error
}

protocol NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol? { get set }
    func parse(code: Int, json: JSON) -> Error
}

extension NetworkErrorParserProtocol {
    func containsError(json: JSON, key: String, code: String) -> Bool {
        return json[key].array?.contains(where: { $0["code"].stringValue == code }) ?? false
    }
}

class NetworkErrorResolver: NetworkErrorResolverProtocol {
    private var parserChain: NetworkErrorParserProtocol
    
    init(parsers: [NetworkErrorParserProtocol]) {
        var parsers = parsers
        var currParser: NetworkErrorParserProtocol!
        
        while !parsers.isEmpty {
            let tmp = currParser
            currParser = parsers.last!
            currParser.next = tmp
            parsers.removeLast()
        }
        
        parserChain = currParser
    }
    
    func resolve(code: Int, json: JSON) -> Error {
        return parserChain.parse(code: code, json: json)
    }
}
