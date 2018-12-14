//
//  NetworkErrorResolverFactory.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol NetworkErrorResolverFactoryProtocol {
    func createDefaultErrorResolver() -> NetworkErrorResolverProtocol
    func createResendConfirmEmailErrorResolver() -> NetworkErrorResolverProtocol
    func createConfirmAddDeviceErrorResolver() -> NetworkErrorResolverProtocol
    func createAddDeviceErrorResolver() -> NetworkErrorResolverProtocol
    func createSendErrorResolver() -> NetworkErrorResolverProtocol
    func createSocialAuthErrorResolver() -> NetworkErrorResolverProtocol
    func createChangePasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createConfirmResetPasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createResetPasswordErrorResolver() -> NetworkErrorResolverProtocol
    func createRegistrationErrorResolver() -> NetworkErrorResolverProtocol
    func createLoginErrorResolver() -> NetworkErrorResolverProtocol
    func createEmailConfirmErrorResolver() -> NetworkErrorResolverProtocol
    func createAccountsErrorResolver() -> NetworkErrorResolverProtocol
}


class NetworkErrorResolverFactory: NetworkErrorResolverFactoryProtocol {
    
    func createDefaultErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createResendConfirmEmailErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createConfirmAddDeviceErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createAddDeviceErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createSendErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            SendNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createSocialAuthErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createChangePasswordErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            TokenRevokeNetworkErrorParser(),
            ChangePasswordNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createConfirmResetPasswordErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            ConfirmResetPasswordErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createResetPasswordErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            EmailNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createRegistrationErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createLoginErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            EmailNetworkErrorParser(),
            AuthNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createEmailConfirmErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
    func createAccountsErrorResolver() -> NetworkErrorResolverProtocol {
        let parsers: [NetworkErrorParserProtocol] = [
            EmptyAccountListNetworkErrorParser(), // should be the first check
            InitialNetworkErrorParser(),
            DeviceNetworkErrorParser(),
            NetworkUnknownErrorParser()
        ]
        return NetworkErrorResolver(parsers: parsers)
    }
    
}
