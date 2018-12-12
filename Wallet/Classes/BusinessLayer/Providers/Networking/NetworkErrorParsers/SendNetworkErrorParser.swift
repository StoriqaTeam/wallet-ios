//
//  SendNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SendNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        if containsError(json: json, key: "exchange_rate", code: "expired") {
            return SendNetworkError.orderExpired
        }
        if containsError(json: json, key: "value", code: "not_enough_balance") {
            return SendNetworkError.notEnoughBalance
        }
        if containsError(json: json, key: "value", code: "not_enough_on_market") {
            return SendNetworkError.exceedRateLimit
        }
        
        if let accountErrors = json["account"].array,
            let existsError = accountErrors.first(where: { $0["code"] == "currency" }),
            let params = existsError["params"].dictionary,
            let accountCurrencyStr = params["account_currency"]?.string,
            let receivedCurrencyStr = params["received_currency"]?.string {
            let accountCurrency = Currency(string: accountCurrencyStr)
            let receivedCurrency = Currency(string: receivedCurrencyStr)
            
            return SendNetworkError.wrongCurrency(message:
                "\(receivedCurrency.ISO) can't be transferred to \(accountCurrency.ISO) accounts")
        }
        
        if let amountErrors = json["actual_amount"].array,
            let existsError = amountErrors.first(where: { $0["code"] == "limit" }),
            let params = existsError["params"].dictionary,
            let min = params["min"]?.string,
            let max = params["max"]?.string,
            let currencyStr = params["currency"]?.string {
            let currency = Currency(string: currencyStr)
            
            return SendNetworkError.amountOutOfBounds(min: min, max: max, currency: currency)
        }
        
        if let accountErrors = json["value"].array,
            let limitError = accountErrors.first(where: { $0["code"] == "exceeded_daily_limit" }),
            let params = limitError["params"].dictionary,
            let limit = params["limit"]?.string,
            let currencyStr = params["currency"]?.string {
            let currency = Currency(string: currencyStr)
            
            // TODO: проверить currency
            return SendNetworkError.exceededDayLimit(limit: limit, currency: currency)
        }
        
        return next!.parse(code: code, json: json)
    }
}

enum SendNetworkError: LocalizedError, Error {
    case wrongCurrency(message: String)
    case orderExpired
    case notEnoughBalance
    case exceedRateLimit
    case exceededDayLimit(limit: String, currency: Currency)
    case amountOutOfBounds(min: String, max: String, currency: Currency)
    
    var errorDescription: String? {
        switch self {
        case .wrongCurrency(let message):
            return message
        case .amountOutOfBounds,
             .exceededDayLimit:
            return ""
        case .notEnoughBalance:
            return "Account balance is not enough"
        case .orderExpired:
            return "Current exchange order did expire"
        case .exceedRateLimit:
            return "At the moment, the exchange of this amount is not possible, please try again later"
        }
    }
}
