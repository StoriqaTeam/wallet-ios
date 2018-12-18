//
//  PaymentRequestResolver.swift
//  Wallet
//
//  Created by Storiqa on 18/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct PaymentRequest {
    let currency: Currency
    let address: String
    let amount: Decimal
}

protocol PaymentRequestResolverProtocol {
    func resolve(string: String) -> PaymentRequest?
}

class PaymentRequestResolver: PaymentRequestResolverProtocol {
    
    private let cryptoAddressResolver: CryptoAddressResolverProtocol
    
    init(cryptoAddressResolver: CryptoAddressResolverProtocol) {
        self.cryptoAddressResolver = cryptoAddressResolver
    }
    
    func resolve(string: String) -> PaymentRequest? {

        guard let url = standartize(string: string) else { return nil }
        guard let scheme = url.scheme else { return nil }
        guard scheme == "ethereum" else { return nil }
        
        guard let address = url.host else { return nil }
        guard let currency = cryptoAddressResolver.resove(address: address) else { return nil }
        guard currency == .eth else { return nil }
        
        guard let params = composeParametersDictionary(from: url.absoluteString) else { return nil }
        guard let amount = getAmount(from: params) else { return nil }
        
        return PaymentRequest(currency: currency, address: address, amount: amount)
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
        guard !params.isEmpty else { return nil }
        
        for (key, value) in params where key == "amount" {
            return Decimal(string: value)
        }
        
        return nil
    }
    
    private func standartize(string: String) -> URL? {
        if string.isEmpty { return nil }
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        guard let failUrl = URL(string: str) else { return nil }
        guard let scheme = failUrl.scheme else { return nil }
        return URL(string: failUrl.absoluteString.replacingOccurrences(of: scheme+":", with: "\(scheme)://"))
    }
}
