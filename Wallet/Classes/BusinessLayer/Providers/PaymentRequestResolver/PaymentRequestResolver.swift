//
//  PaymentRequestResolver.swift
//  Wallet
//
//  Created by Storiqa on 27/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct PaymentRequest {
    let amount: Decimal
    let currency: Currency
    let blockchainAddress: String
}


protocol PaymentRequestResolverProtocol {
    func resolvePayment(request: String) -> PaymentRequest?
}


class PaymentRequestResolver: PaymentRequestResolverProtocol {
    
    private let cryptoAddressResolver: CryptoAddressResolverProtocol
    
    init(cryptoAddressResolver: CryptoAddressResolverProtocol) {
        self.cryptoAddressResolver = cryptoAddressResolver
    }
    
    func resolvePayment(request: String) -> PaymentRequest? {
        
        if let standardizedUrl = standardized(string: request) {
            guard let scheme = standardizedUrl.scheme else { return nil }
            
            if scheme == "iban" {
                
                guard let address = standardizedUrl.host else { return nil }
                guard let currency = cryptoAddressResolver.resove(address: address) else { return nil }
                guard let params = composeParametersDictionary(from: standardizedUrl.absoluteString) else {
                    return PaymentRequest(amount: 0, currency: currency, blockchainAddress: address)
                }
                
                guard let token = getToken(from: params),
                    let amountTokens = getAmount(from: params) else {
                        guard let currency = cryptoAddressResolver.resove(address: request) else { return nil }
                        let address = request
                        return PaymentRequest(amount: 0, currency: currency, blockchainAddress: address)
                }
                
                return PaymentRequest(amount: amountTokens, currency: token, blockchainAddress: address)
            }
            
            return nil
        }
        
        guard let currency = cryptoAddressResolver.resove(address: request) else { return nil }
        let address = request
        return PaymentRequest(amount: 0, currency: currency, blockchainAddress: address)
    }
}


// MARK: - Private methods

extension PaymentRequestResolver {
    private func composeParametersDictionary(from urlString: String) -> [String: String]? {
        guard let queryItems = URLComponents(string: urlString)?.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
    
    private func getAmount(from params: [String: String]) -> Decimal? {
        guard !params.isEmpty else {
            return nil
        }
        
        for (key, value) in params where key == "amount" {
            return Decimal(string: value)
        }
        
        return nil
    }

    private func getToken(from params: [String: String]) -> Currency? {
        guard !params.isEmpty else {
            return nil
        }
        
        for (key, value) in params where key == "token" {
            return Currency(string: value)
        }
        
        return nil
    }
    
    private func standardized(string: String) -> URL? {
        guard let url = URL(string: string) else { return nil }
        guard let scheme = url.scheme else { return nil }
        var absoluteString = url.absoluteString
        
        guard absoluteString.range(of: "://") == nil else { return url }
        let lastIndex = scheme.count + 1
        let indx = string.index(string.startIndex, offsetBy: lastIndex)
        absoluteString.insert("/", at: indx)
        absoluteString.insert("/", at: indx)
        
        guard let standardizedUrl = URL(string: absoluteString) else { return nil }
        return standardizedUrl
    }
    
}
